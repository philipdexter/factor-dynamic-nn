! Copyright (C) 2018 Philip Dexter.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors arrays kernel locals math math.vectors random
sequences sequences.extras vectors ;

IN: dynamic-nn

TUPLE: nn-set els ;

TUPLE: nn-el pos closest-pos distance ;

CONSTANT: initial-capacity 32

: <nn-set> ( -- nn-set )
    initial-capacity <vector> nn-set boa ;

: <nn-el> ( pos closest-pos distance -- nn-el )
    nn-el boa ;

:: find-closest ( pos nn-set -- pos distance )
    nn-set els>> empty? [
        f f
    ] [
        nn-set els>> [ pos>> pos [ [ >float ] map ] bi@ distance ] map [ ] infimum-by*
        swap nn-set els>> nth pos>>
        swap
    ] if ;

:: update-if-closer ( pos nn-el -- )
    nn-el pos>> pos [ [ >float ] map ] bi@ distance :> new-distance
    nn-el distance>> [
        new-distance > [
            nn-el
            new-distance >>distance
            pos >>closest-pos
            drop
        ] when
    ] [
        nn-el
        new-distance >>distance
        pos >>closest-pos
        drop
    ] if* ;

:: insert ( pos nn-set -- )
    nn-set els>> empty? [
        pos f f <nn-el> 1vector nn-set els<<
    ] [
        ! see if any existing elements should be updated
        nn-set els>> [ pos swap update-if-closer ] each
        ! process new element and insert
        pos pos nn-set find-closest <nn-el>
        nn-set els>> push
    ] if ;

ERROR: key-not-present ;

<PRIVATE

:: find-closest-skipping ( pos nn-set skip -- pos distance )
    nn-set els>> length 1 <= [
        f f
    ] [
        nn-set els>> [ skip = [ drop 1/0. ] [ pos>> pos distance ] if ] map-index [ ] infimum-by*
        swap nn-set els>> nth pos>>
        swap
    ] if ;

:: update-el ( el i nn-set -- )
    el pos>> nn-set i find-closest-skipping
    el
    swap >>distance
    swap >>closest-pos
    drop ;

:: (delete) ( pos nn-set i -- )
    i nn-set els>> remove-nth! [ closest-pos>> pos = ] filter
    [ nn-set update-el ] each-index ;

PRIVATE>

: delete ( pos nn-set -- )
    2dup els>> [ pos>> ] map index [
        (delete)
    ] [
        2drop key-not-present throw
    ] if* ;

: random-pos ( -- pos ) random-32 random-32 2array ; inline

:: bench ( to-insert -- )
    <nn-set> :> nn-set
    to-insert [ random-pos nn-set insert ] times ;
