class ArthistController < ApplicationController
  def create
    params.each do |key, value|
      params[key] = value.to_i if integer_string?(value)
    end
    flash.each do |key, value|
      flash[key] = ""
    end

    if params[:arthist].empty?
      flash[:name] = 'アーティスト名を入力してください'
      render('home/set_arthist')
    elsif !(UArthist.where(account:session[:user_name]).where(arthist: params[:arthist]).empty?)
      flash[:name] = 'そのアーティストは既に登録されています'
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


    if (UArthist.where(arthist: ua.arthist).sum(:gender)) /art.count == 1
      art.gender = "男"
    else
      art.gender = "女"
    end

    genre1 = UArthist.where(arthist: art.name).group(:genre1).order('count(id) desc').first
    art.genre1 =
    case genre1.genre1
    when 1
     "J-ROCK"
    when 2
      "JPOP"
    when 3
      "ROCK"
    when 4
      "POPS"
    end

    genre = UArthist.where(arthist: art.name).group(:genre2).order('count(id) desc').first
    art.genre2 = set_genre2(genre1.genre1,genre.genre2)

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
    art.pick_up =
    case genre.pick_up
    when 1
     1
    when 2
      2
    when 3
      3
    when 4
      4
    when 5
      5
    end
    art.save
  end

  @@gender
  @@voice
  @@length
  @@lyrics
  @@genre1
  @@genre2
  @@lyrics_genre

  def fu_result_re
    arthist =
    case @@gender
    when 1
       Arthist.where(gender: "男")
    when  2
       Arthist.where(gender: "女")
    else
       Arthist.all
    end

    if @@voice != 0 && !(@@voice.blank?)
      arthist.where!(voice: @@voice)
    end


    if @@length != 0 && !(@@length.blank?)
      arthist.where!(length: @@length)
    end


    if @@lyrics != 0 && !(@@lyrics.blank?)
      arthist.where!(lyrics: @@lyrics)
    end

    case @@genre1
    when 1
       arthist.where!(genre1: "J-ROCK")
    when 2
       arthist.where!(genre1: "J-POP")
    when 3
       arthist.where!(genre1: "ROCK")
    when 4
      arthist.where!(genre1: "POPS")
    end

    if @@genre2 != 0
      genre2 = set_genre2(params[:genre1],@@genre2)
      arthist.where!(genre2: genre2)
    end

    case @@lyrics_genre
    when "1"
       arthist.where!(lyrics_genre: "応援系")
    when "2"
       arthist.where!(lyrics_genre: "政治系")
    when "3"
       arthist.where!(lyrics_genre: "社会系")
    when "4"
       arthist.where!(lyrics_genre: "恋愛系")
    when "5"
       arthist.where!(lyrics_genre: "季節系")
    when "6"
       arthist.where!(lyrics_genre: "ネタ系")
    when "7"
       arthist.where!(lyrics_genre: "その他")
    end

    @arthist = arthist.page(params[:page]).per(5).order('name ASC')
    render("arthist/fu_result")
  end

  def fu_result

    params.each do |key, value|
      params[key] = value.to_i if integer_string?(value)
    end

    @@gender = params[:gender]
    arthist =
    case params[:gender]
    when 1
       Arthist.where(gender: "男")
    when  2
       Arthist.where(gender: "女")
    else
       Arthist.all
    end

    @@voice = params[:voice]

    if params[:voice] != 0 && !(params[:voice].blank?)
      arthist.where!(voice: params[:voice])
    end

    @@length = params[:length]
    if params[:length] != 0 && !(params[:length].blank?)
      arthist.where!(length: params[:length])
    end

    @@lyrics = params[:lyrics]
    if params[:lyrics] != 0 && !(params[:lyrics].blank?)
      arthist.where!(lyrics: params[:lyrics])
    end

    @@genre1 = params[:genre1]
    case params[:genre1]
    when 1
       arthist.where!(genre1: "J-ROCK")
    when 2
       arthist.where!(genre1: "J-POP")
    when 3
       arthist.where!(genre1: "ROCK")
    when 4
      arthist.where!(genre1: "POPS")
    end

    @@genre2 = params[:genre2]
    if params[:genre2] != 0
      genre2 = set_genre2(params[:genre1],params[:genre2])
      arthist.where!(genre2: genre2)
    end

    @@lyrics_genre = params[:lyrics_genre]
    case params[:lyrics_genre]
    when "1"
       arthist.where!(lyrics_genre: "応援系")
    when "2"
       arthist.where!(lyrics_genre: "政治系")
    when "3"
       arthist.where!(lyrics_genre: "社会系")
    when "4"
       arthist.where!(lyrics_genre: "恋愛系")
    when "5"
       arthist.where!(lyrics_genre: "季節系")
    when "6"
       arthist.where!(lyrics_genre: "ネタ系")
    when "7"
       arthist.where!(lyrics_genre: "その他")
    end

    @arthist = arthist.page(params[:page]).per(5).order('name ASC')
  end


  def set_genre2(genre1,genre2)
    case genre1
    when 1
      case genre2
      when 1
        return "メロコア"
      when 2
        return "パンク"
      when 3
        return "ラウド"
      when 4
        return "メタル"
      when 5
        return "オルタナティブ"
      when 6
        return "ミクスチャー"
      when 7
        return "その他"
      end
    when 2
      case genre2
      when 1
        return "アニソン"
      when 2
        return "演歌"
      when 3
        return "アイドル"
      when 4
        return "その他"
      end
    when 3
      case genre2
      when 1
        return "メロコア"
      when 2
        return "パンク"
      when 3
        return "ラウド"
      when 4
        return "メタル"
      when 5
        return "オルタナティブ"
      when 6
        return "ミクスチャー"
      when 7
        return "その他"
      end
    when 4
      case genre2
      when 1
        return "アニソン"
      when 2
        return "演歌"
      when 3
        return "アイドル"
      when 4
        return "その他"
      end
    end
  end
end
