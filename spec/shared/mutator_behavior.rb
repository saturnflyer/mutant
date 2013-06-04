shared_examples_for 'a mutator' do
  subject { object.each(node) { |item| yields << item } }

  let(:yields) { []              }
  let(:object) { described_class }

  unless instance_methods.map(&:to_s).include?('node')
    let(:node) { parse(source) }
  end

  it_should_behave_like 'a command method'

  context 'with no block' do
    subject { object.each(node) }

    it { should be_instance_of(to_enum.class) }

    def assert_transitive(ast)
      generated = generate(ast)
      parsed    = parse(generated)
      again     = generate(parsed)
      unless generated == again
        fail "Untransitive:\n%s\n---\n%s" % [generated, again]
      end
    end

    unless instance_methods.include?(:expected_mutations)
      let(:expected_mutations)  do
        mutations.map do |mutation|
          case mutation
          when String
            ast = parse(mutation)
            assert_transitive(ast)
            ast
          when Rubinius::AST::Node
            assert_transitive(mutation)
            mutation
          else
            raise
          end
        end.map do |node|
          generate(node)
        end.to_set
      end
    end

    it 'generates the expected mutations' do
      generated  = self.subject.map { |mutation| generate(mutation) }.to_set

      missing    = (expected_mutations - generated).to_a
      unexpected = (generated - expected_mutations).to_a

      unless generated == expected_mutations
        fail "Missing mutations:\n%s\nUnexpected mutations:\n%s" % [missing.join("\n----\n"), unexpected.join("\n----\n")]
      end
    end
  end
end

shared_examples_for 'a noop mutator' do
  let(:mutations) { [] }

  it_should_behave_like 'a mutator'
end
