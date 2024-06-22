import Toybox.Lang;
import Toybox.Test;

module FailTest {
  (:test)
  function testFailureOne(logger as Logger) as Boolean {
    Test.assertEqualMessage(1, -1, "1 is equal to -1");
    return true;
  }
}
