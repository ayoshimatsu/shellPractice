@test 'addition using arithmetic expansion' {
    value=$((5 + 3))
    [[ $value -eq 8 ]]
}

@test 'addition negative value using arithmetic expansion' {
    value=$((5 + -7))
    [[ $value -eq -2 ]]
}

@test 'addition zero using arithmetic expansion' {
    value=$((3 + 0))
    [[ $value -eq 3 ]]
}
