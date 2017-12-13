# Apache 2.0 License
#
# Copyright (c) Copyright 2016 Sebastian Katzer, appPlant GmbH
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
