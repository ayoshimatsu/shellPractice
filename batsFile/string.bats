@test 'string concatenation' {
    value=aaa
    value+=bbb
    [[ $value == aaabbb ]]
}
