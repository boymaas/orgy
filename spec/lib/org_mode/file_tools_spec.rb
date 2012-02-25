require 'org_mode/file_tools'


describe OrgMode::FileTools do
  context "#backup" do
    before do
      # assume backup dir exist
      File.stub(:exist? => true)
    end
    it "copies to the correct dir" do
      OrgMode::FileTools.stub(:_extract_unique_extentions => [1,2,3,4,5,8])
      OrgMode::FileTools.stub(:backup_dir => '/tmp/backups/' )
      OrgMode::FileTools.should_receive(:cp).with('blah', '/tmp/backups/blah.9').and_return(true)

      OrgMode::FileTools.backup('blah')
    end
  end

  context "#_unique_extention" do
    context "with existing files" do
      it 'determines a correct unique extention' do
        Dir.stub(:[]).and_return(['blah.1', 'blah.2', 'blah.3'])
        OrgMode::FileTools.send(:_unique_extention, 'blah').
          should == 4
          
      end
    end
    context "with no files" do
      it 'determines a correct unique extention' do
        Dir.stub(:[]).and_return([])
        OrgMode::FileTools.send(:_unique_extention, 'blah').
          should == 0
      end
    end
  end

end
