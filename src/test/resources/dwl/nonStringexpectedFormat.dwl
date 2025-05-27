%dw 2.0
output application/json writeAttributes=true
ns ns0 ecolab.com/CDM:1
import * from dw::util::Values
fun treeFilter(value: Any, predicate: (value:Any) -> Boolean) =
    value  match {
	case object is Object ->  do {
		object mapObject ((value, key, index) ->
                    (key): treeFilter(value, predicate)) filterObject ((value, key, index) -> predicate(value))
	}
            case array is Array -> do {
		array map ((item, index) -> treeFilter(item, predicate)) filter ((item, index) -> predicate(item))
	}
            else -> $
}
fun filterEmpty(value: Any) =
    treeFilter (value, (value) ->
    value match {
	case v is Array| Object | Null | "" -> !isEmpty(v)
        else -> true
})
---
filterEmpty(vars.expectedPayload)