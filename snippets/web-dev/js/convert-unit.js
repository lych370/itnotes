const unitConvert = function unitConvert(size) {
  if (typeof size != 'number') {
    return '传入的不是数字';
  }

  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  let unit = 'B';
  for (let index = 0; index < units.length; index++) {
    if (size >= 1024) {
      size = size / 1024, 2;
      unit = units[index + 1];
    }
  }

  return size.toFixed(2) + unit;
};

export default unitConvert;
