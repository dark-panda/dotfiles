<?php

// Place this file in ~/.config/psysh/config.php and have at it.

use Symfony\Component\Console\Formatter\OutputFormatter;
use Illuminate\Support\Arr;

class JSHImpl {
  public $outputFormatter;
  public $enableSQLLog;
  public $enableSQLBacktrace;
  public $enableSQLFormatting;

  public function __construct() {
    $this->setupEvents();
    $this->cycleColors = [ 'cyan', 'magenta' ];
    $this->outputFormatter = new OutputFormatter(true, []);
    $this->enableSQLLog = true;
    $this->enableSQLBacktrace = false;
    $this->enableSQLFormatting = true;
    $this->limitSQLBindingsLength = 1000;

    declare(ticks = 1);

    pcntl_signal(SIGTERM, function ($signal) {
      $this->handleSignal($signal);
    });

    pcntl_signal(SIGTERM, function ($signal) {
      $this->handleSignal($signal);
    });
  }

  public function timing(Callable $closure) {
    $start = microtime(true);
    $ret = $closure();
    $elapsed = round((microtime(true) - $start) * 1000, 2);

    $coloredString = $this->outputFormatter->format("  <fg=yellow>TIMING (%.2fms)</fg=yellow>");

    $this->puts(sprintf($coloredString, $elapsed));
    return $ret;
  }

  public function puts() {
    foreach (func_get_args() as $arg) {
      echo $arg, PHP_EOL;
    }
  }

  public function cycle(&$arr) {
    $ret = current($arr);
    next($arr);

    if (!current($arr)) {
      reset($arr);
    }

    return $ret;
  }

  private function formatQuery($query) {
    if (!$this->enableSQLFormatting) {
      return $query;
    }

    $formattedQuery = SqlFormatter::format($query, false);
    $formattedQuery = preg_replace('/((@) (>))/', '\2\3', $formattedQuery);

    return $formattedQuery;
  }

  public function putsSQL($query, $time) {
    $color = $this->cycle($this->cycleColors);
    $coloredString = $this->outputFormatter->format("  <fg={$color}>SQL (%.2fms)</fg={$color}>  %s");
    $formattedQuery = $this->formatQuery($query);

    $this->puts(sprintf($coloredString, $time, $formattedQuery));

    if ($this->enableSQLBacktrace) {
      $this->showBacktrace();
    }
  }

  public function showBacktrace() {
    $lines = array_filter(debug_backtrace(DEBUG_BACKTRACE_IGNORE_ARGS), function ($line) {
      static $break = false;

      if ($break) {
        return false;
      }

      if (isset($line['class']) && ($line['class'] === self::class || $line['class'] === 'JSH')) {
        return false;
      }

      if (isset($line['file']) && $line['file'] === __FILE__) {
        $break = true;
        return false;
      }

      return true;
    });

    $this->puts($this->outputFormatter->format("  <fg=yellow>BACKTRACE:</fg=yellow>"));

    foreach ($lines as $i => $line) {
      $calledAt = [
        Arr::get($line, 'class'),
        Arr::get($line, 'type'),
        Arr::get($line, 'function')
      ];

      $output = sprintf(
        "#%d\t%s called at [%s:%d]",
        $i,
        implode($calledAt),
        (isset($line['file']) ? $line['file'] : 'internal'),
        (isset($line['line']) ? $line['line'] : '')
      );

      $this->puts($output);
    }
  }

  private function setupEvents() {
    Event::listen('illuminate.query', function($query, $bindings, $time, $connectionName) {
      if (!$this->enableSQLLog) {
        return;
      }

      $conn = \DB::connection($connectionName);

      // Format binding data for sql insertion
      $prepareBindings = $conn->prepareBindings($bindings);

      foreach ($prepareBindings as $i => $binding) {
        if ($binding === null) {
          $prepareBindings[$i] = 'null';
        }
        else {
          if ($this->limitSQLBindingsLength && strlen($binding) > $this->limitSQLBindingsLength) {
            $binding = substr($binding, 0, $this->limitSQLBindingsLength) . ' --%<-- SNIP!';
          }

          $prepareBindings[$i] = $conn->getPdo()->quote($binding);
        }
      }

      // Insert bindings into query
      $preparedQuery = str_replace(array('%', '?'), array('%%', '%s'), $query);
      $preparedQuery = vsprintf($preparedQuery, $prepareBindings);

      $this->putsSQL($preparedQuery, $time);
    });
  }

  private function handleSignal($signal) {
    switch ($signal) {
      case SIGTERM:
        print "Caught SIGTERM\n";
      // exit;
        break;

      case SIGKILL:
        print "Caught SIGKILL\n";
        // exit;
        break;

      case SIGINT:
        print "Caught SIGINT\n";
        // exit;
        break;
    }
  }
}

class JSH {
  public static function getGlobalInstance() {
    if (!isset($GLOBALS['JSH'])) {
      $GLOBALS['JSH'] = new JSHImpl();
    }

    return $GLOBALS['JSH'];
  }

  public static function __callStatic($name, $arguments) {
    return call_user_func_array([ $GLOBALS['JSH'], $name ], $arguments);
  }

  public static function enableSQLBacktrace() {
    self::getGlobalInstance()->enableSQLBacktrace = true;
  }

  public static function disableSQLBacktrace() {
    self::getGlobalInstance()->enableSQLBacktrace = false;
  }

  public static function enableSQLLog() {
    self::getGlobalInstance()->enableSQLLog = true;
  }

  public static function disableSQLLog() {
    self::getGlobalInstance()->enableSQLLog = false;
  }

  public static function enableSQLFormatting() {
    self::getGlobalInstance()->enableSQLFormatting = true;
  }

  public static function disableSQLFormatting() {
    self::getGlobalInstance()->enableSQLFormatting = false;
  }

  public static function limitSQLBindingsLength($length) {
    self::getGlobalInstance()->limitSQLBindingsLength = $length;
  }
}

JSH::getGlobalInstance();

return array(
  // In PHP 5.4+, PsySH will default to your `cli.pager` ini setting. If this
  // is not set, it falls back to `less`. It is recommended that you set up
  // `cli.pager` in your `php.ini` with your preferred output pager.
  //
  // If you are running PHP 5.3, or if you want to use a different pager only
  // for Psy shell sessions, you can override it here.
  'pager' => 'less -R',

  // Sets the maximum number of entries the history can contain.
  // If set to zero, the history size is unlimited.
  'historySize' => 2000,

  // If set to true, the history will not keep duplicate entries.
  // Newest entries override oldest.
  // This is the equivalent of the HISTCONTROL=erasedups setting in bash.
  'eraseDuplicates' => true,

  // By default, PsySH will use a 'forking' execution loop if pcntl is
  // installed. This is by far the best way to use it, but you can override
  // the default by explicitly enabling or disabling this functionality here.
  'usePcntl' => true,

  // PsySH uses readline if you have it installed, because interactive input
  // is pretty awful without it. But you can explicitly disable it if you hate
  // yourself or something.
  'useReadline' => true,

  // PsySH automatically inserts semicolons at the end of input if a statement
  // is missing one. To disable this, set `requireSemicolons` to true.
  'requireSemicolons' => false,

  // While PsySH respects the current `error_reporting` level, and doesn't throw
  // exceptions for all errors, it does log all errors regardless of level. Set
  // `errorLoggingLevel` to 0 to prevent logging non-thrown errors. Set it to any
  // valid `error_reporting` value to log only errors which match that level.
  //'errorLoggingLevel' => E_ALL & ~E_NOTICE,

  // "Default includes" will be included once at the beginning of every PsySH
  // session. This is a good place to add autoloaders for your favorite
  // libraries.
  //'defaultIncludes' => array(
  //  __DIR__ . '/include/bootstrap.php',
  //),

  // While PsySH ships with a bunch of great commands, it's possible to add
  // your own for even more awesome. Any Psy command added here will be
  // available in your Psy shell sessions.
  //'commands' => array(

    // The `parse` command is a command used in the development of PsySH.
    // Given a string of PHP code, it pretty-prints the
    // [PHP Parser](https://github.com/nikic/PHP-Parser) parse tree. It
    // prolly won't be super useful for most of you, but it's there if you
    // want to play :)
    //new \Psy\Command\ParseCommand,
  //),

  // PsySH uses symfony/var-dumper's casters for presenting scalars, resources,
  // arrays and objects. You can enable additional casters, or write your own!
  // See http://symfony.com/doc/current/components/var_dumper/advanced.html#casters
  //'casters' => array(
  //  'MyFooClass' => 'MyFooClassCaster::castMyFooObject',
  //),

  // You can disable tab completion if you want to. Not sure why you'd want to.
  //'tabCompletion' => false,

  // You can write your own tab completion matchers, too! Here are some that enable
  // tab completion for MongoDB database and collection names:
  //'tabCompletionMatchers' => array(
  //  new \Psy\TabCompletion\Matcher\MongoClientMatcher,
  //  new \Psy\TabCompletion\Matcher\MongoDatabaseMatcher,
  //),

  // If multiple versions of the same configuration or data file exist, PsySH will
  // use the file with highest precedence, and will silently ignore all others. With
  // this enabled, a warning will be emitted (but not an exception thrown) if multiple
  // configuration or data files are found.
  //
  // This will default to true in a future release, but is false for now.
  //'warnOnMultipleConfigs' => true,
);
