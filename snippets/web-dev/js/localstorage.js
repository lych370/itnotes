//存储各种信息
const storage = {
  //存入数据
  save(key, val, type) {
    if (type === 'session') {
      sessionStorage.setItem(key, JSON.stringify(val));
    } else {
      localStorage.setItem(key, JSON.stringify(val));
    }
  },
  //取出数据
  get(key) {
    if (sessionStorage.getItem(key)) {
      return JSON.parse(sessionStorage.getItem(key))||[];
    }
    return JSON.parse(localStorage.getItem(key)) || [];
  },
  //当前用户的登录数据
  loginData: {
    save() {},
    get() {}
  },
  //删除数据
  remove(key) {
    if (localStorage.getItem(key)) {
      localStorage.removeItem(key);
    } else {
      sessionStorage.removeItem(key);
    }
  }
};
export default storage;
