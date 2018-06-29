const multiSelect = function(allCheckboxs,isChecked) {
  //勾选时 所有文件添加选中状态
  if (isChecked) {
    switchChecked(allCheckboxs, true);
  } else {
    switchChecked(allCheckboxs, false);
  }

  function switchChecked(allCheckboxs, checkState) {
    for (const checkbox of allCheckboxs) {
      checkbox.checked = checkState;
    }
  }
};

export default multiSelect;
