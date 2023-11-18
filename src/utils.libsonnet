{
	cleanTextBlock(text):: std.rstripChars(text, '\n'),
	hide(obj, fields):: std.foldl(function(acc, curr) acc { [curr]:: std.get(acc, curr) }, fields, obj),
}
