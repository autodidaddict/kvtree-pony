use "ponytest"
use "collections"
use "json"

use ".."

class iso _TestJSON is UnitTest
  """
  Tests the JSON functionality of a KVNode 
  """
  fun name(): String => "kvnode/json"

  fun apply(h: TestHelper) ? =>
    let node: KVNode = KVNode("hello", "world")

    h.assert_eq[String]("\"world\"", node.json_value()?)
    h.assert_eq[String]("""{"hello":"world"}""", node.to_json()?)

    let node1 = KVNode(None, "hello")
    let node2 = KVNode(None, "world")
    let greetings = KVNode("greetings", recover val [node1; node2] end)
    let expected = """{"greetings":["hello","world"]}"""
    h.assert_eq[String](expected, greetings.to_json()?)

    let node3 = KVNode(None, "ciao")
    let node4 = KVNode(None, "later")
    let partings = KVNode("partings", recover val [node3; node4] end)

    let root = KVNode(None, recover val [greetings; partings] end)
    let expected2 = """{"greetings":["hello","world"],"partings":["ciao","later"]}"""
    h.assert_eq[String](expected2, root.to_json()?)

    let balance = KVNode("balance", I64(1250))
    let account = KVNode("account", "Savings")
    let bankwrap = KVNode(None, recover val [balance; account; greetings] end)
    let bank = KVNode("bank", bankwrap)
    let expected3 =
    """{"bank":{"balance":1250,"account":"Savings","greetings":["hello","world"]}}"""
    h.assert_eq[String](expected3, bank.to_json()?)
