class Public::RecipesController < ApplicationController
  def show
   @recipe=Recipe.find(params[:id])
   @store = @recipe.store
   @recipe_comment=RecipeComment.new
  end

  def index
    #お気に入りしたレシピを配列として表す
    favorites = Favorite.where(user_id: current_public_user.id).pluck(:recipe_id)
    @recipes = Recipe.find(favorites)
    #配列をページング
    @recipes =  Kaminari.paginate_array(@recipes).page(params[:page]).per(2)
  end

  def search
    #セレクトボックス
    @stores = Store.where("genre LIKE ?", "%#{params[:genre]}%")&&
    @stores = Store.where("area LIKE ?", "%#{params[:area]}%")&&
    @stores = Store.where("station LIKE ?", "%#{params[:station]}%")
    @recipes = Recipe.where(store_id: @stores.pluck(:id))



    # オブジェクトであるレシーバーの値が存在するか否か
    if params[:search_word].present?
      store = Store.find_by(genre: params[:search_word])
      if store
        store_recipes = store.recipes
      else
        store = Store.find_by(area: params[:search_word])
        if store
          store_recipes = store.recipes
        else
          store = Store.find_by(station: params[:search_word])
          if store
            store_recipes = store.recipes
          else
            store_recipes = []
          end
        end
      end
      @recipes =  store_recipes

    else
      @recipes = Recipe.none
    end
  end


   private

    def recipe_params
      params.require(:recipe).permit(:store_id, :cooking_name, :recipe, :amount, :image)
    end

end