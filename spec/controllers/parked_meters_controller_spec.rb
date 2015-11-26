require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe ParkedMetersController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # ParkedMeter. As you add validations to ParkedMeter, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ParkedMetersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all parked_meters as @parked_meters" do
      parked_meter = ParkedMeter.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:parked_meters)).to eq([parked_meter])
    end
  end

  describe "GET show" do
    it "assigns the requested parked_meter as @parked_meter" do
      parked_meter = ParkedMeter.create! valid_attributes
      get :show, {:id => parked_meter.to_param}, valid_session
      expect(assigns(:parked_meter)).to eq(parked_meter)
    end
  end

  describe "GET new" do
    it "assigns a new parked_meter as @parked_meter" do
      get :new, {}, valid_session
      expect(assigns(:parked_meter)).to be_a_new(ParkedMeter)
    end
  end

  describe "GET edit" do
    it "assigns the requested parked_meter as @parked_meter" do
      parked_meter = ParkedMeter.create! valid_attributes
      get :edit, {:id => parked_meter.to_param}, valid_session
      expect(assigns(:parked_meter)).to eq(parked_meter)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ParkedMeter" do
        expect {
          post :create, {:parked_meter => valid_attributes}, valid_session
        }.to change(ParkedMeter, :count).by(1)
      end

      it "assigns a newly created parked_meter as @parked_meter" do
        post :create, {:parked_meter => valid_attributes}, valid_session
        expect(assigns(:parked_meter)).to be_a(ParkedMeter)
        expect(assigns(:parked_meter)).to be_persisted
      end

      it "redirects to the created parked_meter" do
        post :create, {:parked_meter => valid_attributes}, valid_session
        expect(response).to redirect_to(ParkedMeter.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved parked_meter as @parked_meter" do
        post :create, {:parked_meter => invalid_attributes}, valid_session
        expect(assigns(:parked_meter)).to be_a_new(ParkedMeter)
      end

      it "re-renders the 'new' template" do
        post :create, {:parked_meter => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested parked_meter" do
        parked_meter = ParkedMeter.create! valid_attributes
        put :update, {:id => parked_meter.to_param, :parked_meter => new_attributes}, valid_session
        parked_meter.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested parked_meter as @parked_meter" do
        parked_meter = ParkedMeter.create! valid_attributes
        put :update, {:id => parked_meter.to_param, :parked_meter => valid_attributes}, valid_session
        expect(assigns(:parked_meter)).to eq(parked_meter)
      end

      it "redirects to the parked_meter" do
        parked_meter = ParkedMeter.create! valid_attributes
        put :update, {:id => parked_meter.to_param, :parked_meter => valid_attributes}, valid_session
        expect(response).to redirect_to(parked_meter)
      end
    end

    describe "with invalid params" do
      it "assigns the parked_meter as @parked_meter" do
        parked_meter = ParkedMeter.create! valid_attributes
        put :update, {:id => parked_meter.to_param, :parked_meter => invalid_attributes}, valid_session
        expect(assigns(:parked_meter)).to eq(parked_meter)
      end

      it "re-renders the 'edit' template" do
        parked_meter = ParkedMeter.create! valid_attributes
        put :update, {:id => parked_meter.to_param, :parked_meter => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested parked_meter" do
      parked_meter = ParkedMeter.create! valid_attributes
      expect {
        delete :destroy, {:id => parked_meter.to_param}, valid_session
      }.to change(ParkedMeter, :count).by(-1)
    end

    it "redirects to the parked_meters list" do
      parked_meter = ParkedMeter.create! valid_attributes
      delete :destroy, {:id => parked_meter.to_param}, valid_session
      expect(response).to redirect_to(parked_meters_url)
    end
  end

end