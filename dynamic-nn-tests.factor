! Copyright (C) 2018 Philip Dexter.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel tools.test dynamic-nn ;
IN: dynamic-nn.tests

{ T{ nn-set f V{ } } } [ <nn-set> ] unit-test

{ T{ nn-set f V{ T{ nn-el f { 0 0 } f f } } } } [ <nn-set> dup { 0 0 } swap insert ] unit-test

{ T{ nn-set f V{ T{ nn-el f { 0 0 } { 0 1 } 1.0 } T{ nn-el f { 0 1 } { 0 0 } 1.0 } } } } [ <nn-set> dup { 0 0 } swap insert dup { 0 1 } swap insert ] unit-test

{ T{ nn-set f V{ T{ nn-el f { 0 0 } { 0 3 } 3.0 } T{ nn-el f { 0 3 } { 0 0 } 3.0 } } } } [ <nn-set> dup { 0 0 } swap insert dup { 0 1 } swap insert dup { 0 3 } swap insert dup { 0 1 } swap delete ] unit-test

{ T{ nn-set f V{ T{ nn-el f { 0 3 } f f } } } } [ <nn-set> dup { 0 0 } swap insert dup { 0 1 } swap insert dup { 0 3 } swap insert dup { 0 1 } swap delete dup { 0 0 } swap delete ] unit-test
