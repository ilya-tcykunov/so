require 'spec_helper'

describe Attachment do
  it { should belong_to :attachmentable }
  it {should validate_presence_of :attachmentable}
end
