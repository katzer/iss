#
# Copyright (c) 2016 by appPlant GmbH. All rights reserved.
#
# @APPPLANT_LICENSE_HEADER_START@
#
# This file contains Original Code and/or Modifications of Original Code
# as defined in and that are subject to the Apache License
# Version 2.0 (the 'License'). You may not use this file except in
# compliance with the License. Please obtain a copy of the License at
# http://opensource.org/licenses/Apache-2.0/ and read it before using this
# file.
#
# The Original Code and all software distributed under the License are
# distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
# EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
# INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
# Please see the License for the specific language governing rights and
# limitations under the License.
#
# @APPPLANT_LICENSE_HEADER_END@

def override_fifa(status = 0)
  ISS::Fifa.define_method(:exec) { [yield, status == 0] }
end

def override_ski(status = 0)
  ISS::Ski.define_method(:exec) { [yield, status == 0] }
end

assert 'ISS::LFV#planet_ids', 'when exitstatus = 0' do
  override_fifa(0) { %w[p1 p2] }

  ids = ISS::LFV.planet_ids

  assert_kind_of Array, ids
  assert_equal %w[p1 p2], ids
end

assert 'ISS::LFV#planet_ids', 'when exitstatus = 1' do
  override_fifa(1) { ['error'] }

  ids = ISS::LFV.planet_ids

  assert_kind_of Array, ids
  assert_true ids.empty?
end

assert 'ISS::LFV#include?' do
  override_fifa { ['p1'] }

  assert_true  ISS::LFV.include?('p1')
  assert_false ISS::LFV.include?('p2')
end

assert 'ISS::LFV.valid?' do
  override_fifa { ['p1'] }

  assert_true  ISS::LFV.new('p1').valid?
  assert_false ISS::LFV.new('p2').valid?
end

assert 'ISS::LFV.planet_id' do
  assert_equal 'p1', ISS::LFV.new('p1').planet_id
end

assert 'ISS::LFV.planet_id' do
  assert_equal 'p1', ISS::LFV.new('p1').planet_id
end

assert 'ISS::LFV.file_ids' do
  override_fifa { ['p1'] }
  override_ski  { %w[f1 f2] }

  assert_equal %w[f1 f2], ISS::LFV.new('p1').file_ids
  assert_true ISS::LFV.new('p2').file_ids.empty?
end

assert 'ISS::LFV.include?' do
  override_fifa { ['p1'] }
  override_ski  { %w[f1 f2] }

  assert_true  ISS::LFV.new('p1').include? 'f1'
  assert_false ISS::LFV.new('p1').include? 'f3'
  assert_false ISS::LFV.new('p2').include? 'f1'
end

assert 'ISS::LFV.find' do
  override_fifa { ['p1'] }
  override_ski  { %w[f1 f2] }

  file = ISS::LFV.new('p1').find('f1')

  assert_kind_of Logfile, file
  assert_equal 'f1', file.id
  assert_equal 'p1', file.planet_id
end

assert 'ISS::LFV.find', 'when planet is not available' do
  override_fifa { ['p1'] }
  override_ski  { %w[f1 f2] }

  assert_nil ISS::LFV.new('p2').find('f1')
end

assert 'ISS::LFV.find', 'when file is not available' do
  override_fifa { ['p1'] }
  override_ski  { %w[f1 f2] }

  assert_nil ISS::LFV.new('p1').find('f3')
end

assert 'ISS::LFV.files' do
  override_fifa { ['p1'] }
  override_ski  { %w[f1 f2] }

  files = ISS::LFV.new('p1').files

  assert_kind_of Array, files
  assert_equal 2, files.count

  file = files.first

  assert_kind_of Logfile, file
  assert_kind_of String, file.id
  assert_equal 'p1', file.planet_id
end

assert 'ISS::LFV.files', 'when planet is not available' do
  override_fifa { ['p1'] }
  override_ski  { %w[f1 f2] }

  assert_true ISS::LFV.new('p2').files.empty?
end
