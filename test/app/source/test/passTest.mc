import Toybox.Lang;
import Toybox.Test;

module PassTest {
  (:test)
  function testSuccessOne(logger as Logger) as Boolean {
    Test.assertEqualMessage(1, 1, "1 is equal to 1");
    return true;
  }
}
