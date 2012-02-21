# -*- coding: utf-8 -*-
#
# @file 
# @brief
# @author ongaeshi
# @date   2011/02/20

require 'test_helper'
require 'milkode/cdstk/package.rb'

class TestPackage < Test::Unit::TestCase
  include Milkode

  def test_same_name?
    p1 = Package.create('/path/to/dir')
    p2 = Package.create('/path/to/dir')
    p3 = Package.create('/path/to/d2')
    p4 = Package.create('/path/to/dir', ["*.bak"])

    assert p1.same_name? p2.name
    assert !p1.same_name?(p3.name)
    assert p1.same_name? p4.name
  end

  def test_eql
    p1 = Package.create('/path/to/dir')
    p2 = Package.create('/path/to/dir')
    p3 = Package.create('/path/to/d2')
    p4 = Package.create('/path/to/dir', ["*.bak"])

    assert p1 == p2
    assert p1 != p3
    assert p1 != p4
  end

end