class OrderItem
  class StateError < StandardError; end
  module State
    STATES = [:new, :approved, :declined, :start_prepare, :end_prepare, :served]

    STATES.each_with_index do |state, index|
      eval("#{state.to_s.upcase} = #{index}")
    end

    def self.state_number(state)
      STATES.index state
    end

    def self.state(state_number)
      state_number.nil? ? nil : STATES[state_number]
    end

    def state=(state)
      self.state_cd = State.state_number state
    end

    def state
      State.state(self.state_cd)
    end

    STATES.each do |state|
      eval(
          <<-eos
  def #{state}?
    self.state == :#{state}
  end
      eos
      )
    end
  end
end