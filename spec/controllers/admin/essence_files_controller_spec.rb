require "spec_helper"

module Alchemy
  describe Admin::EssenceFilesController do
    before do
      sign_in(admin_user)
    end

    let(:essence_file) { mock_model('EssenceFile', :attachment= => nil, content: content) }
    let(:content)      { mock_model('Content') }
    let(:attachment)   { mock_model('Attachment') }

    describe '#edit' do
      before do
        expect(EssenceFile).to receive(:find)
          .with(essence_file.id.to_s)
          .and_return(essence_file)
      end

      it "assigns @essence_file with the EssenceFile found by id" do
        get :edit, id: essence_file.id
        expect(assigns(:essence_file)).to eq(essence_file)
      end

      it "should assign @content with essence_file's content" do
        get :edit, id: essence_file.id
        expect(assigns(:content)).to eq(content)
      end
    end

    describe '#update' do
      before do
        expect(EssenceFile).to receive(:find).and_return(essence_file)
      end

      it "should update the attributes of essence_file" do
        expect(essence_file).to receive(:update).and_return(true)
        xhr :put, :update, id: essence_file.id
      end
    end

    describe '#assign' do
      before do
        expect(Content).to receive(:find_by).and_return(content)
        expect(Attachment).to receive(:find_by).and_return(attachment)
        allow(content).to receive(:essence).and_return(essence_file)
      end

      it "should assign @attachment with the Attachment found by attachment_id" do
        xhr :put, :assign, content_id: content.id, attachment_id: attachment.id
        expect(assigns(:attachment)).to eq(attachment)
      end

      it "should assign @content.essence.attachment with the attachment found by id" do
        expect(content.essence).to receive(:attachment=).with(attachment)
        xhr :put, :assign, content_id: content.id, attachment_id: attachment.id
      end
    end
  end
end
