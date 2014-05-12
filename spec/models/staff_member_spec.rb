require 'spec_helper'

describe StaffMember do
  fixtures :staff_members

  describe '#online?' do
    let(:staff_member) { staff_members(:one) }

    describe 'when staff member has been seen with the last 15 minutes' do

      before :each do
        staff_member.last_seen = Time.now-(60*12)
      end

      it 'should return true' do
        expect(staff_member.online?).to be(true)
      end

    end

    describe 'when staff member has not been seen with the last 15 minutes' do

      before :each do
        staff_member.last_seen = Time.now-(60*16)
      end

      it 'should return true' do
        expect(staff_member.online?).to be(false)
      end

    end

  end

  describe '.online' do
    let(:staff_member_one) { staff_members(:one) }
    let(:staff_member_two) { staff_members(:two) }

    describe 'when there are online members' do

      before :each do
        staff_member_one.last_seen = Time.now-(60*12)
        staff_member_one.save!
        staff_member_two.last_seen = Time.now-(60*17)
        staff_member_two.save!
      end

      it 'should return one staff member' do
        expect(StaffMember.online(1).size).to be(1)
      end

    end

  end

end