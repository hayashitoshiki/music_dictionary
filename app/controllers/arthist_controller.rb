class ArthistController < ApplicationController
  def create
    params.each do |key, value|
      params[key] = value.to_i if integer_string?(value)
    end
    flash.each do |key, value|
      flash[key] = ""
    end

    i = 0
    if params[:arthist].empty?
      flash[:name] = 'アーティスト名を入力してください'
      i = 1
    elsif !(UArthist.where(account:session[:user_name]).where(arthist: params[:arthist]).empty?)
      flash[:name] = 'そのアーティストは既に登録されています'
      i = 1
    end
    if params[:gender].blank?
      flash[:gender] = 'ボーカルの性別を選んでください'
      i = 1
    end
    if params[:voice].blank?
      flash[:voice] = 'ボーカルの声の高さを入力してください'
      i = 1
    end
    if params[:length].blank?
      flash[:length] = '曲の平均の長さを入力してください'
      i = 1
    end
    if params[:lyrics].blank?
      flash[:lyrics] = '曲の平均の言語の割合を選んでください'
      i = 1
    end
    if params[:genre1].eql?(0)
      flash[:genre1] = 'アーティストのジャンルを入力してください'
      i = 1
    end
    if params[:genre2].eql?(0)
      flash[:genre2] = 'アーティストの詳しいジャンルを入力してください'
      i = 1
    end
    if params[:lyrics_genre].eql?(0)
      flash[:lyrics_genre] = 'アーティストの歌詞の特徴を選んでください'
      i = 1
    end

    if i==1
      @name = params[:arthist]
      @gender = params[:gender]
      @voice = params[:voice]
      @length = params[:length]
      @lyrics = params[:lyrics]
      @genre1 = params[:genre1]
      @genre2 = params[:genre2]
      @lyrics_genre = params[:lyrics_genre]
      render('home/set_arthist')
    else
    ua = UArthist.new(arthist: params[:arthist], gender: params[:gender],
                                 voice: params[:voice], length: params[:length], lyrics: params[:lyrics],
                                 genre1: params[:genre1], genre2: params[:genre2], lyrics_genre: params[:lyrics_genre],
                                 generation: User.find_by_name(session[:user_name]).age, pick_up: params[:pick_up], account: session[:user_name])
    ua.save
    if Arthist.where(name: params[:arthist]).empty?
      art = Arthist.new(name: params[:arthist], count: 1)
      art.save
    else
      art = Arthist.where(name: params[:arthist]).first
      art.update_attributes(count: art.count + 1)
    end
    arthist_update(art,ua)

    redirect_to('/account')
  end
  end

  def update
    params.each do |key, value|
      params[key] = value.to_i if integer_string?(value)
    end

    ua = UArthist.find_by(id: params[:id])
    art = Arthist.where(name: ua.arthist).first
    ua.update_attributes( gender: params[:gender], voice: params[:voice], length: params[:length],
       lyrics: params[:lyrics],genre1: params[:genre1], genre2: params[:genre2],
       lyrics_genre: params[:lyrics_genre],generation: User.find_by_name(session[:user_name]).age,
       pick_up: params[:pick_up], account: session[:user_name])

    arthist_update(art,ua)
    redirect_to('/account')
  end

  def delete
    ua = UArthist.where(arthist: params[:arthist]).where(account: session[:user_name]).first
    ua.destroy
    art = Arthist.where(name: params[:arthist]).first
    if art.count == 1
      art.destroy
    else
      art.update_attributes(count: art.count-1)
      arthist_update(art,ua)
    end
    redirect_to('/account')
  end

  def show_db
    @uarthists = UArthist.all
    @arthists = Arthist.all
    @users = User.all
    @warn = WarnArthist.all
    @wuas = WarnUArthist.all
    end

  def integer_string?(str)
    Integer(str)
    true
  rescue ArgumentError
    false
  end

  def arthist_update(art,ua)
    art.update_attributes(
      voice: (UArthist.where(arthist: ua.arthist).sum(:voice)) / (art.count).round,
      length: (UArthist.where(arthist: ua.arthist).sum(:length)) / (art.count).round,
      lyrics: (UArthist.where(arthist: ua.arthist).sum(:lyrics)) / (art.count).round,
      generation1: UArthist.where(arthist: art.name).where(generation: 5..19).count,
      generation2: UArthist.where(arthist: art.name).where(generation: 20..29).count,
      generation3: UArthist.where(arthist: art.name).where(generation: 30..39).count,
      generation4: UArthist.where(arthist: art.name).where(generation: 40..49).count,
      generation5: UArthist.where(arthist: art.name).where(generation: 50..59).count,
      generation6: UArthist.where(arthist: art.name).where(generation: 60..100).count)


    if ((UArthist.where(arthist: art.name).sum(:gender)) /art.count).round == 1
      art.gender = "男"
    else
      art.gender = "女"
    end

    genre1 = UArthist.where(arthist: art.name).group(:genre1).order('count(id) desc').first
    art.genre1 = genre1.genre1

    genre = UArthist.where(arthist: art.name).group(:genre2).order('count(id) desc').first
    art.genre2 = genre.genre2

    genre = UArthist.where(arthist: art.name).group(:lyrics_genre).order('count(id) desc').first
    art.lyrics_genre =
    case genre.lyrics_genre
    when 1
     "応援系"
    when 2
      "政治系"
    when 3
      "社会系"
    when 4
      "恋愛系"
    when 5
      "季節系"
    when 6
      "ネタ系"
    when 7
      "その他"
    end

    genre = UArthist.where(arthist: art.name).group(:pick_up).order('count(id) desc').first
    art.pick_up = genre.pick_up
    art.save
  end
end
