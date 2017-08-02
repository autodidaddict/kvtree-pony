use "collections"

type NodeValueType is (I16 | I32 | I64 | String val | Bool | Array[KVNode val] val | KVNode val)

type NodeKeyType is (String val | None)

class val KVNode
  let _key: NodeKeyType  
  let _value: NodeValueType
  
  new val create(key': NodeKeyType, value': NodeValueType) =>
    _key = key'
    _value = value'

  fun key(): NodeKeyType =>
    _key

  fun value(): NodeValueType =>
    _value

  fun string(): String val =>
    match _value
    | let v: Array[KVNode] val => "(" + _key.string() + ", ...)"
    | let v: (I16 | I32 | I64 | String val | Bool | KVNode val) => "(" + _key.string() + ", " + v.string() + ")"    
    end 

  fun json_value(): String val ? =>
    match _value
    | let n: (I16 | I32 | I64 | Bool) => n.string()
    | let v: String val => "\"" + v.string() + "\""
    | let v: Array[KVNode] val => 
      _array_to_json(v)?
    else            
      (_value as KVNode val).to_json()?
    end

  fun tag _array_to_json(v: Array[KVNode] val): String val ? =>
    let middle: String val = recover val 
        let o = String
        var i:USize = 0
        for n in v.values() do
          o.append(n.to_json(false)?)
          if i < (v.size()-1) then
            o.append(",")
          end
          i=i+1
        end
        o
      end
    if v(0)?.key() is None then 
      "[" + middle + "]"
    else
      middle 
    end

  fun to_json(wrapper: Bool = true): String val ? =>
    let x: String val =
    match _key 
    | let k: String val => "\"" + k + "\":" + json_value()? 
    else
      json_value()?
    end
    if wrapper == true then
      "{" + x + "}"
    else 
      x
    end
