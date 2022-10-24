describe "POST /signup" do
  context "novo usuario" do
    before(:all) do
      payload = { name: "Bonner", email: "bonner@uol.com.br", password: "pwd123" }
      MongoDB.new.remove_user(payload[:email])

      @result = Signup.new.create(payload)
    end

    it "valida status code" do
      expect(@result.code).to eql 200
    end

    it "valida id do usuário" do
      expect(@result.parsed_response["_id"].length).to eql 24
    end
  end

  context "usuario ja existe" do
    before(:all) do
      # Dado que eu tenho um novo usuário
      payload = { name: "Joao silva", email: "joao@uol.com.br", password: "pwd123" }
      MongoDB.new.remove_user(payload[:email])

      # E o email desse usuário ja foi cadastrado no sistema
      Signup.new.create(payload)

      # quando faço uma requisição para a rota /signup
      @result = Signup.new.create(payload)
    end
    it "Deve retornar 409" do
      #entao deve retornar 409
      expect(@result.code).to eql 409
    end

    it "deve retornar mensagem" do
      expect(@result.parsed_response["error"]).to eql "Email already exists :("
    end
  end
end
