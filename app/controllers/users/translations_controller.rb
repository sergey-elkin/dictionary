class Users::TranslationsController < Users::BaseController
  helper_method :translations, :translation, :lang

  def index
    require_user
  end

  def new
    require_user
    authorize! :create, Translation.new.user = requested_user
  end

  def create
    require_user
    authorize! :create, Translation.new.user = requested_user
    unless requested_user.translations.get_translations(params[:translation])
      render :action => :new and return
    end
    render :action => :index
  end

  def edit
    require_user
    authorize! :update, translation
  end

  def show
    require_user
  end

  def update
    require_user
    authorize! :update, translation
  end

  def destroy
    require_user
    authorize! :update, translation
    requested_user.translations.find(params[:id]).destroy
    redirect_to user_translations_path(requested_user)
  end

private

  def translations
    TranslationDecorator.decorate_collection(requested_user.translations)
  end

  def translation
    return @translation if defined?(@translation)
    @translation = TranslationDecorator.decorate(requested_user.translations.find(params[:id]))
  end
end
