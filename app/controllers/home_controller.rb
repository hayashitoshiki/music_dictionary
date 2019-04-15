class HomeController < ApplicationController
  def home
    if session[:user_name].blank?
      render('home/start')
    else
      @arthist = Arthist.ransack(params[:q])
      art =UArthist.where(account: session[:user_name]).count
      if 0 < (count = 3 - art)
        @check = "検索するにはあと"+count.to_s+"組アーティスト情報を登録してください"
      end
    end
  end

  def result
    @arthist = Arthist.ransack(params[:q])
    @art = Arthist.search(arthist_params)
    @arthists = @art.result.order(name: "ASC").page(params[:page]).per(10)
    @result_count = @arthists.total_count
    @wuas = WarnUArthist.all
    render('home/home')
    #@arthist = Arthist.where(name: params[:arthist]).first
  end

  def arthist_params
    params.require(:q).permit!
  end

  def new_account
    flash.each do |key, value|
      flash[key] = ""
    end
   end

  def start; end

  def login; end

  def account
    @notice = "ユーザー名：#{session[:user_name]}"
    @arthists = UArthist.where(account: session[:user_name]).order(arthist: "ASC").page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.js
    end

  end

  def set_arthist
    flash.each do |key, value|
      flash[key] = ""
    end
  end

  def update_arthist
    @arthist = UArthist.where(arthist: params[:arthist]).where(account: session[:user_name]).first
  end

  def create
    flash.each do |key, value|
      flash[key] = ""
    end
    switch = 0
    if params[:name].blank?
      flash[:name] = 'ユーザー名を設定してください'
      switch = 1
    elsif !(User.where(name: params[:name]).empty?)
      flash[:name] = 'この名前はすでに登録されています'
      switch = 1
    end
    if params[:email].blank?
      flash[:email] = 'メールアドレスを入力してください'
      switch = 1
    end
    if params[:pw].blank?
      flash[:pw] = 'パスワードを設定してください'
      switch = 1
    elsif params[:pw].length < 6
      flash[:pw] = '半角英数６文字以上で入力してください'
      switch = 1
    elsif !(params[:pw].eql?(params[:pw2]))
      flash[:pw2] = '同じパスワードを入力してください'
      switch = 1
    end
    if params[:gender].blank?
      flash[:gender] = '性別を選択してください'
      switch = 1
    end
    if params[:year].blank? || params[:month].blank? || params[:day].blank?
      flash[:birthday] = '生年月日を入力してください'
      switch = 1
    end


    if switch == 0
      date_format = "%Y%m%d"
      birthday = (params[:year]+format("%02d",params[:month])+format("%02d",params[:day])).to_i
      age = (Date.today.strftime(date_format).to_i - birthday) / 10000
      @user = User.new(name: params[:name], email: params[:email], password: params[:pw],age: age, birthday: birthday, gender: params[:gender])
      @user.save
      session[:user_name] = params[:name]
      redirect_to('/')
    else
      @gender = params[:gender]
      @email = params[:email]
      @name = params[:name]
      render('home/new_account')
    end
  end

  def login_check
    @notice = "#{session[:user_name]}でログインしています。" if session[:user_name]

    if params.key?(:name) || params.key?(:password)
      @name = params[:name]
      if user = User.find_by_name(params[:name])
        if user.authenticate(params[:password])
          date_format = "%Y%m%d"
          user.update_attributes(age: (Date.today.strftime(date_format).to_i - user.birthday) / 10000)
          session[:user_name] = params[:name]
          redirect_to('/',alert: "ログイン成功")
        else
          flash[:notice] = nil
          flash[:ps] = 'パスワードが間違っています'
          render('home/login')
        end
      else
        flash[:ps] = nil
        flash[:notice] = 'アカウントが存在しません'
        render('home/login')
     end
   end
  end

  def integer_string?(str)
    Integer(str)
    true
  rescue ArgumentError
    false
  end

  def sign_out
    session[:user_name] = nil
    redirect_to('/')
  end

  def set_warning
    art = Arthist.find_by(id: params[:id])
    if WarnArthist.where(name: art.name).empty?
      w_art = WarnArthist.new(name: art.name)
      if params[:warning_val] == "1"
        w_art.wrong_name = 1
        w_art.exist_name = 0
      else
        w_art.wrong_name = 0
        w_art.exist_name = 1
      end
    else
      w_art = WarnArthist.where(name: art.name).first
      if params[:warning_val] == "1"
        w_art.wrong_name += 1
      else
        w_art.exist_name += 1
      end
    end
    w_art.save
    w_u_art = WarnUArthist.new(user: session[:user_name], arthist: art.name)
    w_u_art.save
    redirect_to("/")
  end
end
