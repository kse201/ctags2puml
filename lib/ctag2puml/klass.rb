require 'erb'

module Ctag2Puml
  class Klass
    attr_accessor :name, :file, :members
    def initialize(name, file)
      self.name = name
      self.file = file.gsub('.py','')
      self.members = []
    end

    def add_members(member)
      self.members.push member
    end

    def template
      File.read(File.expand_path('../template.erb', __FILE__))
    end

    def to_s
      ERB.new(template, nil, '-').result(binding)
    end

    @dict = Hash.new { |_, _| }

    class << self
      def dict
        @dict
      end

      def get(name, file)
        dict["#{file}+#{name}".to_sym] ||= self.new(name, file)
      end
      alias_method :create, :get

      def all
        dict.each_value
      end
    end
  end
end
