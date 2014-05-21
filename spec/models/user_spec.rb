require 'spec_helper'

describe User do
  it { should have_many :answers }
  it { should have_many :questions }
  it { should have_many :comments }
end
