# -*- coding: utf-8 -*-
#
# @file 
# @brief
# @author ongaeshi
# @date   2012/02/21

require 'yaml'
require 'pathname'
require 'milkode/common/util'
require 'milkode/cdstk/package'

module Milkode
  class MilkodeYaml
    MILKODE_YAML_VERSION = '0.2'

    EMPTY_YAML = <<EOF
---
version: '#{MILKODE_YAML_VERSION}'
contents: []
EOF

    attr_reader :contents
    
    def initialize(str = nil)
      @data = YAML.load(str || EMPTY_YAML)
      @contents = parse_contents
    end

    def dump
      YAML.dump(@data)
    end

    def version
      @data['version']
    end

    # パッケージを追加
    def add(package)
      @contents.push package
      update_contents
    end

    # 同名パッケージの内容を置き換え
    def update(package)
      i = @contents.find_index {|v| v.same_name?(package.name) }
      raise unless i
      @contents[i] = package
      update_contents
    end

    # パッケージを削除
    def remove(package)
      @contents.delete(package)
      update_contents
    end

    # 名前が同じパッケージを検索
    def find_name(name)
      @contents.find {|v| v.same_name?(name)}
    end

    # マイグレーション
    def migrate
      if (version != MILKODE_YAML_VERSION)
        # バージョン番号
        @data['version'] = MILKODE_YAML_VERSION

        # パッケージ
        contents.each{|v| v.migrate}

        # migrateが起きた
        true
      else
        false
      end
    end

    private

    def parse_contents
      @data['contents'].map do |v|
        Package.new(v)
      end
    end

    def update_contents
      @data['contents'] = @contents.map{|v| v.hash }
    end
  end
end
