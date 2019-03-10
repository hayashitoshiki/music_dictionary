$('#genre1').change(function() {
  var val = $('#genre1').val();
  if(val == "J-ROCK" || val == "ROCK"){
    $('select#genre2 option').remove();
    $('#genre2').append('<option value=" ">指定なし</option>');
    $('#genre2').append('<option value="メロコア">メロコア</option>');
    $('#genre2').append('<option value="パンク">パンク</option>');
    $('#genre2').append('<option value="ラウド">ラウド</option>');
    $('#genre2').append('<option value="メタル">メタル</option>');
    $('#genre2').append('<option value="オルタナティブ">オルタナティブ</option>');
    $('#genre2').append('<option value="ミクスチャー">ミクスチャー</option>');
    $('#genre2').append('<option value="その他">その他</option>');
  }else if(val == "J-POP"){
    $('select#genre2 option').remove();
    $('#genre2').append('<option value="0">指定なし</option>');
    $('#genre2').append('<option value="アニソン">アニソン</option>');
    $('#genre2').append('<option value="演歌">演歌</option>');
    $('#genre2').append('<option value="アイドル">アイドル</option>');
    $('#genre2').append('<option value="その他">その他</option>');
  }else{
    $('select#genre2 option').remove();
    $('#genre2').append('<option value="0">　　　　</option>');
  }
});
