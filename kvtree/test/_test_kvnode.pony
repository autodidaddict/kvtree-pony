use "ponytest"
use "collections"
use "json"

use ".."

class iso _TestKVNode is UnitTest
  """
  Tests the basic functionaliy of a KVNode 
  """
  fun name(): String => "kvtree/KVNode"

  fun apply(h: TestHelper) ? =>
    let node: KVNode = KVNode("hello", "world")

    h.assert_eq[String]("(hello, world)", node.string())
    h.assert_true(true)

    let keyless: KVNode = KVNode(None, "world")
    h.assert_eq[String]("(None, world)", keyless.string())

    // Two nodes
    let node1 = KVNode("hello", "world")
    let node2 = KVNode("goodbye", "world")
    let greetings = KVNode("greetings", recover val [node1; node2] end)
    h.assert_eq[USize](2, (greetings.value() as Array[KVNode val] val).size())   

    let nest = KVNode("nested", greetings)
    h.assert_eq[String](nest.key() as String, "nested")
    let target = ((nest.value() as KVNode val).value() as Array[KVNode] val)
    h.assert_eq[USize](2, target.size())