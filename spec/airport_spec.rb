require 'airport.rb'
require 'rspec/expectations'


describe Airport do
  subject(:airport) { described_class.new }
  let(:plane) {double :plane}
  let(:weather) {double :weather}

    it { expect(subject).to respond_to(:accept_for_landing).with(1).argument}
    it { expect(subject).to respond_to(:accept_for_take_off).with(1).argument}
    # it {expect(subject).to respond_to(:airport_space)}

    describe '#initialize' do
      it "airport has a variable capacity" do
        capacity = 123
        airport = Airport.new(capacity)
        expect(airport.capacity).to eq 123
      end
      it "sets the the capacity to default value when capacity is not provided" do
    	  expect(subject.capacity).to eq(Airport::DEFAULT_CAPACITY)
      end
      # it "has parking space" do
      #   expect(subject.airport_space).to eq []
      # end
      it "will start working with no planes in it, therefore none can take off " do
        expect{subject.accept_for_take_off(plane)}.to raise_error("There are no planes in the Airport")
      end
      # it "knows its planes" do
      #   subject.accept_for_landing(plane)
      #   expect(subject.planes).to include plane
      # end
      # it "can't have planes parked when they are took off" do
      #   subject.accept_for_landing(plane)
      #   subject.accept_for_take_off(plane)
      #   expect(subject.planes).to_not include plane
      # end
    end
        describe '#accept_for_landing' do
          before {allow(subject).to receive(:any_landed?).and_return(false)}

          it "accepts planes for landing when the weather is fine" do
            # allow(plane).to receive(:airport_space)
            allow(plane).to receive(:reported_landed).and_return(true)
            allow(subject).to receive(:stormy_weather?).and_return(false)
            subject.accept_for_landing(plane)
            allow(subject).to receive(:any_landed?).and_return(true)
            allow(plane).to receive(:took_off).and_return(true)
            subject.accept_for_take_off(plane)
            expect(plane).to eq plane
            # expect(subject.airport_space).to eq [plane]
          end
          it "raises an error message when the weather is too stormy to land" do
           allow(plane).to receive(:reported_landed).and_return(true)
           allow(subject).to receive(:stormy_weather?).and_return(true)
          #  subject.accept_for_landing(plane)
           expect {subject.accept_for_landing(plane)}.to raise_error "It's too stormy to land"
          end
          it "raises exception if Airport is full" do
            allow(plane).to receive(:reported_landed).and_return(true)
            allow(weather).to receive(:stormy_weather?).and_return(3)
            allow(subject).to receive(:stormy_weather?).and_return(false)
           Airport::DEFAULT_CAPACITY.times {subject.accept_for_landing(plane)}
           expect {subject.accept_for_landing(plane)}.to raise_error("Airport is full")
          end
          it "will not allow planes to land when they are already on the ground" do
            allow(subject).to receive(:any_landed?).and_return(true)
            expect{subject.accept_for_landing(plane)}.to raise_error "Already landed"
          end
        end
        describe '#accept_for_take_off' do
          before  do
            allow(subject).to receive(:any_landed?).and_return(false)
            allow(plane).to receive(:reported_landed).and_return(true)
            allow(subject).to receive(:stormy_weather?).and_return(false)
            subject.accept_for_landing(plane)
            allow(subject).to receive(:any_landed?).and_return(true)
          end
            it "sets a plane into the air if the weather is fine" do
              allow(plane).to receive(:took_off?).and_return(true)
              allow(weather).to receive(:stormy_weather?).and_return(3)
              allow(subject).to receive(:stormy_weather?).and_return(true)
              subject.accept_for_take_off(plane)
              expect{subject.accept_for_take_off(plane)}.to raise_error "It's too stormy to takeoff"
            end
            # subject.accept_for_landing(plane)
            # expect(subject.planes[0]).to eq plane
            # subject.accept_for_take_off(plane)
            # expect(subject.airport_space).to eq []
            it "it won't allow the planes to take off if they already did" do
              allow(subject).to receive(:any_landed?).and_return(false)
              expect{subject.accept_for_take_off(plane)}.to raise_error "the plane is no longer in the airport"
            end
            it "will only send the plane into the sky if it's in the airport" do
              landed_plane = double(:plane, any_landed?: true)
              expect{subject.accept_for_take_off(landed_plane)}.to raise_error "There are no planes in the Airport"
            end
          end

      # it "raises an error if the weather is stormy for take off" do
      #   subject.accept_for_landing(plane)
      #   subject.accept_for_take_off(plane)
      #   expect {subject.accept_for_take_off}.to raise_error("It's too stormy to takeoff")

  #      it "after it took off it will no longer exist in the airport" do
  #	      subject.accept_for_landing(plane)
			#   subject.acceprt_for_take_off
			#   expect(subject.planes).to eq []
      # end

end
