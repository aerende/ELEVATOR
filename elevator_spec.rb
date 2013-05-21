#!/usr/bin/ruby

#  1.  There are floor buttons which call the elevator and elevator buttons which select floors for the elevator to move to
#  2.  Both the floor buttons and elevator buttons use the same Button class
#  3.  Calling the ElevatorController.move method moves the elevator to the next floor.
#  4.  The elevator buttons have priority over the floor buttons wrt the movement of the elevator


module EM

  class Button
    attr_accessor :pressed, :floor_number
    def initialize(floor_number)
      @pressed = 0
      @floor_number = floor_number
    end

    def pressed_button(pressed)
      @pressed = pressed
    end
  end  # class

  class Elevator
  
    attr_accessor :current_floor, :floor_number
    def initialize(current_floor, floor_number)
      @current_floor = current_floor
      @num_floors = floor_number
    end
  
    def move_up_one
      @current_floor = (@current_floor < @num_floors) ? @current_floor + 1 : @current_floor
    end
    def move_down_one
      @current_floor = (@current_floor > 0) ? @current_floor - 1 : @current_floor
    end

  end  # class

  class ElevatorController

    attr_accessor :number_floors, :button_array, :floor_array
    def initialize(number_floors)
      @number_floors = number_floors
      @button_array = []
      @floor_array  = []
      for i in 0...number_floors do
        @button_array <<  Button.new(i)
        @floor_array  <<  Button.new(i)
      end
      @e = Elevator.new(0, number_floors)
    end


    def move_up_or_down(button_move, b_array)

      b_array.each do |b|
        if    ((b.pressed == 1) && (@e.current_floor < b.floor_number))
          @e.move_up_one
          button_move = 1
        elsif ((b.pressed == 1) && (@e.current_floor > b.floor_number))
          @e.move_down_one
          button_move = 1
        end
        if(button_move == 1) then break; end
      end
      button_move
    end  # move_up_or_down


  
    def move

      @button_array[@e.current_floor].pressed_button(0)
      @floor_array[@e.current_floor].pressed_button(0)


      # move based on elevator button highest priority, then floor button

      button_move = 0

      button_move = move_up_or_down(button_move, @button_array)

      if(button_move == 0)
        button_move = move_up_or_down(button_move, @floor_array)
      end      # if button_move == 0

    end  # def move


  
  
  
  end  # ElevatorController
  
end  # module



describe "Rspec elevator - button third floor pressed " do
  it "should show third floor button pressed" do
    e = EM::ElevatorController.new(4)
    e.floor_array[3].pressed_button(1)
    e.floor_array[3].pressed.should == 1
  end
  it "should move to the third floor" do
    e = EM::ElevatorController.new(4)
    e.floor_array[3].pressed_button(1)
    e.move
    e.move
    e.move
    e.move
    e.floor_array[3].pressed.should == 0
    e.instance_variable_get(:@e).instance_variable_get(:@current_floor).should == 3
  end
end

describe "Rspec elevator - go to third floor then ground floor " do
  it "should show third floor button pressed" do
    e = EM::ElevatorController.new(4)
    e.floor_array[3].pressed_button(1)
    e.floor_array[3].pressed.should == 1
  end
  it "should move to the third floor" do
    e = EM::ElevatorController.new(4)
    e.floor_array[3].pressed_button(1)
    e.move
    e.move
    e.move
    e.move
    e.floor_array[3].pressed.should == 0
    e.instance_variable_get(:@e).instance_variable_get(:@current_floor).should == 3
  end
  it "should show ground button pressed" do
    e = EM::ElevatorController.new(4)
    e.button_array[0].pressed_button(1)
    e.button_array[0].pressed.should == 1
  end
  it "should move to the ground floor" do
    e = EM::ElevatorController.new(4)
    e.button_array[0].pressed_button(1)
    e.move
    e.move
    e.move
    e.move
    e.button_array[0].pressed.should == 0
    e.instance_variable_get(:@e).instance_variable_get(:@current_floor).should == 0
  end
end













