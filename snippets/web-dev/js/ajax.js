//ajax 传参类似jquery的$.ajax()方法
/* 参数示例
info={
  type:'get',
  url:'xxx',
  data:'xxx',
  async:'false',
  success:function(){},
  fail:function(){}
}
*/
const ajax = function(info) {
  let { type, url, data, async, success, fail } = info;
  //预设值
  type = type || 'post';
  async = async || true;
  data = data || null;

  //回调函数  //回调方法
  const callback = {
    success: function(res) {
      if (success) {
        success(res);
      } else {
        //eslint-disable-next-line no-console
        console.log(
          '服务器成功响应，但是没有传入回调函数进行相关操作。\n你需要在ajax()传入的参数中添加一个success属性，其属性值是一个函数/方法的名字。该函数（方法）至少有一个参数，该参数即是ajax获取到的响应内容。\n示例：ajax({url:aUrl,success:fnName})'
        );
      }
    },
    fail: function(status) {
      if (fail) {
        fail(status);
      } else {
        //eslint-disable-next-line no-console
        console.log('服务器错误：' + status);
      }
    }
  };

  //1. 实例化xhr对象
  const xhr = new XMLHttpRequest();

  //2. 建立请求
  xhr.open(type, url, async);

  //3. 发送请求
  xhr.send(data);

  //4. 获取回应
  xhr.onreadystatechange = function() {
    if (xhr.readyState === 4) {
      if (xhr.status === 200) {
        callback.success(xhr.responseText);
      } else {
        callback.fail(xhr.status);
      }
    }
  };
};
export default ajax;

