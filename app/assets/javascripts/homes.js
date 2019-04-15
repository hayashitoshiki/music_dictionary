$('#genre1').change(function() {
  var val = $('#genre1 option:selected').text();
  if (val == "J-ROCK" || val == "ROCK") {
    $('select#genre2 option').remove();
    $('#genre2').append('<option value=" ">指定なし</option>');
    $('#genre2').append('<option value="メロコア">メロコア</option>');
    $('#genre2').append('<option value="パンク">パンク</option>');
    $('#genre2').append('<option value="ラウド">ラウド</option>');
    $('#genre2').append('<option value="メタル">メタル</option>');
    $('#genre2').append('<option value="オルタナティブ">オルタナティブ</option>');
    $('#genre2').append('<option value="ミクスチャー">ミクスチャー</option>');
    $('#genre2').append('<option value="その他">その他</option>');
  } else if (val == "J-POP" || val == "POPS") {
    $('select#genre2 option').remove();
    $('#genre2').append('<option value=" ">指定なし</option>');
    $('#genre2').append('<option value="アニソン">アニソン</option>');
    $('#genre2').append('<option value="演歌">演歌</option>');
    $('#genre2').append('<option value="アイドル">アイドル</option>');
    $('#genre2').append('<option value="その他">その他</option>');
  } else {
    $('select#genre2 option').remove();
    $('#genre2').append('<option value=" ">　　　　</option>');
  }
});

var tag;

function fade(ele) {
  switch (ele.id) {
    case 'warning':
      tag = "#warning_base";
      break;
    case 'arthist_name':
      tag = "#sreach2";
      break;
  }
  $(this).blur();
  if ($("#overlay")[0]) return false;
  $("body").append('<div id="overlay"></div>');
  $("#overlay").fadeIn("slow");
  centeringModalSyncer();
  $(tag).fadeIn("slow");
}

function fadein(ele,art_id) {
  switch (ele.id) {
    case 'warning':
      tag = "#warning_base";
      break;
  }
  $(this).blur();
  if ($("#overlay")[0]) return false;
  $("body").append('<div id="overlay"></div>');
  $("body").append('<div id="warning_base"><form action="\/set_warning\/'+ art_id +'"  method="get"><input type="radio" name="warning_val" id="" value= "1" >アーティスト名が違う<input type="radio" name="warning_val" id="" value= "2" >存在しないアーティスト<input type="submit" id="update_push" value="送信"  onclick=" return warning_check();"><\/form><\/div>');
  $("#overlay").fadeIn("slow");
  centeringModalSyncer();
  $(tag).fadeIn("slow");
}

$(function() {
  $(document).on("click", "#overlay", function() {
    $(tag).fadeOut("slow");
    $("#overlay").fadeOut("slow", function() {
      $("#overlay").remove();
    });
  });


});
$(window).resize(centeringModalSyncer);

function warning_check(){
  var w_check = confirm("通報したアーティストの情報は確認することが出来なくなります。通報しますか？");
  if(w_check == true){
    return true;
  }else{
    return false;
  }
}


function centeringModalSyncer() {

  var w = $(window).width();
  var h = $(window).height();
  var cw = $(tag).outerWidth();
  var ch = $(tag).outerHeight();
  $(tag).css({"left": ((w - cw) / 2) + "px","top": ((h - ch) / 2) + "px"});
}
