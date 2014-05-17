require 'spec_helper'

describe Comment do
  it { should belong_to :user }
  it { should belong_to :commentable }
  it { should validate_presence_of :user }
  it { should validate_presence_of :commentable }
  it { should validate_presence_of :body }
end
