#
# Copyright (C) 2020 Red Hat Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# == Class: manila::cron::db_purge
#
# Remove deleted records from database
#
# === Parameters
#
#  [*minute*]
#    (optional) Defaults to '1'.
#
#  [*hour*]
#    (optional) Defaults to '0'.
#
#  [*monthday*]
#    (optional) Defaults to '*'.
#
#  [*month*]
#    (optional) Defaults to '*'.
#
#  [*weekday*]
#    (optional) Defaults to '*'.
#
#  [*user*]
#    (optional) User with access to manila files.
#    Defaults to 'manila'.
#
#  [*age*]
#    (optional) Number of days prior to today for deletion,
#    e.g. value 60 means to purge deleted rows that have the "deleted_at"
#    column greater than 60 days ago.
#    Defaults to 0
#
#  [*destination*]
#    (optional) Path to file to which rows should be archived
#    Defaults to '/var/log/manila/manila-rowsflush.log'.
#
#  [*maxdelay*]
#    (optional) In Seconds. Should be a positive integer.
#    Induces a random delay before running the cronjob to avoid running
#    all cron jobs at the same time on all hosts this job is configured.
#    Defaults to 0.
#
#
class manila::cron::db_purge (
  $minute      = 1,
  $hour        = 0,
  $monthday    = '*',
  $month       = '*',
  $weekday     = '*',
  $user        = 'manila',
  $age         = 0,
  $destination = '/var/log/manila/manila-rowsflush.log',
  $maxdelay    = 0,
) {

  include manila::deps

  if $maxdelay == 0 {
    $sleep = ''
  } else {
    $sleep = "sleep `expr \${RANDOM} \\% ${maxdelay}`; "
  }

  cron { 'manila-manage db purge':
    command     => "${sleep}manila-manage db purge ${age} >>${destination} 2>&1",
    environment => 'PATH=/bin:/usr/bin:/usr/sbin SHELL=/bin/sh',
    user        => $user,
    minute      => $minute,
    hour        => $hour,
    monthday    => $monthday,
    month       => $month,
    weekday     => $weekday,
    require     => Anchor['manila::dbsync::end'],
  }
}
