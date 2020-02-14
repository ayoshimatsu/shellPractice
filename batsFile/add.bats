PATH="${BATS_TEST_DIRNAME}:$PATH"

@test 'addition using add.sh command' {
    run add.sh 8 7
    [[ $status -eq 0 ]]
    [[ $output == 15 ]]
}

@test 'addition negative value using add.sh command' {
    run add.sh 2 -9
    [[ $status -eq 0 ]]
    [[ $output == -7 ]]
}
