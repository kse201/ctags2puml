module Ctag2Puml
  class Tag
    attr_accessor :name, :file, :address, :kind, :field, :klass_name
    def initialize(line)
      parse(line)
    end

    [:field, :class, :member, :variable, :file_name].each do |k|
      define_method "#{k}?" do
        kind == k
      end
    end

    private

    def parse(line)
      parsed = line.chomp.split("\t")

      self.name = parsed[0]
      self.file = parsed[1]
      self.address = parsed[2]
      self.field = parsed[3..-1]
      self.kind = case field[0]
                  when 'f'
                    :field
                  when 'c'
                    :class
                  when 'm'
                    :member
                  when 'v'
                    :variable
                  when 'F'
                    :file_name
                  end

      self.klass_name = case kind
                        when :class
                          name
                        when :member
                          field[1].gsub('class:', '')
                        end
    end

    def to_s
      "name: #{name}\n"
    end
  end
end
