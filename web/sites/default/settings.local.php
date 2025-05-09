<?php

// $databases['default']['default'] = [
//   'driver' => 'mysql',
//   'database' => 'drupal10',
//   'username' => 'drupal10',
//   'password' => 'drupal10',
//   'host' => (PHP_SAPI === 'cli' && getenv('IS_DOCKER') !== '1') ? '127.0.0.1' : 'db',
//   'port' => '3306',
//   'prefix' => '',
//   'collation' => 'utf8mb4_general_ci',
//   'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
//   'driver_options' => [],
// ];

$databases['default']['default'] = [
  'driver' => 'mysql',
  'database' => 'drupal10',
  'username' => 'drupal10',
  'password' => 'drupal10',
  'host' => (PHP_SAPI === 'cli' && getenv('IS_DOCKER') !== '1') ? '127.0.0.1' : 'my_drupal_ubuntu_db',
  'port' => '3306',
  'prefix' => '',
  'collation' => 'utf8mb4_general_ci',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver_options' => [],
];

$settings['file_public_path'] = 'sites/default/files';
$config['system.performance']['css']['preprocess'] = TRUE;
$config['system.performance']['js']['preprocess'] = TRUE;

$settings['container_yamls'][] = DRUPAL_ROOT . '/sites/development.services.yml';
$config['system.logging']['error_level'] = 'verbose';

//# Settings for SMTP
//$config['smtp.settings'] = [
//  'transport' => 'smtp',
//  'smtp_host' => 'mailhog',
//  'smtp_port' => '1025',
//  'smtp_protocol' => 'standard',
//  'smtp_on' => TRUE,
//  'smtp_allowhtml' => TRUE,
//  'smtp_debugging' => FALSE
//];
//$config['smtp.settings']['smtp_from'] = "vera.lyalko@bixal.com";
//$config['smtp.settings']['smtp_fromname'] = "Vera Lyalko";

//$base_url = "http://localhost:8000";

//config settings
$settings["config_sync_directory"] = '../config/sync';
// $settings['skip_permissions_hardening'] = TRUE;

// // config split settings
// $config['config_split.config_split.local']['status'] = TRUE;
// $config['config_split.config_split.dev']['status'] = FALSE;
// $config['config_split.config_split.prod']['status'] = FALSE;

//if (getenv('DRUPAL_ENV')) {
//  switch (getenv('DRUPAL_ENV')){
//    case 'local':
//      $config['config_split.config_split.local']['status'] = TRUE;
//      $config['config_split.config_split.dev']['status'] = FALSE;
//      $config['config_split.config_split.prod']['status'] = FALSE;
//    case 'dev':
//      $config['config_split.config_split.local']['status'] = FALSE;
//      $config['config_split.config_split.dev']['status'] = TRUE;
//      $config['config_split.config_split.prod']['status'] = FALSE;
//      break;
//    case 'stage':
//    case 'prod':
//      $config['config_split.config_split.local']['status'] = FALSE;
//      $config['config_split.config_split.dev']['status'] = FALSE;
//      $config['config_split.config_split.prod']['status'] = TRUE;
//      break;
//  }
//}
