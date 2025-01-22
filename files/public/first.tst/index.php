<?php
// Начало времени
$start_time = microtime(true);

sleep(rand(1, 4));

$virtualHost = $_SERVER['HTTP_HOST'];

echo "Имя виртуального хоста: " . $virtualHost;

echo "<br>";

// Завершение времени
$end_time = microtime(true);

// Время выполнения
$execution_time = $end_time - $start_time;

echo "Время выполнения скрипта: " . $execution_time . " секунд.";
