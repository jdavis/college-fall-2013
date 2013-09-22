#lang racket
#|
In this file you can find sevaral examples and explanations that will help
you understand the concept of currying.

Strictly speaking, currying is the process of transforming multiple arg functions to a
sequence of one argument functions that return a one argument function and so on, until
we have as many 1-arg functions as original parameters.
Ex:
|#
(define (greater? n x)
  (> x n))

;>(greater? 10 5)
;#f

;;We transform the above function to:

(define (greater-curry? n)
  (lambda (x) (> x n)))
;;Scheme/Racket's functional nature lets us manipulate functions as values.
;;so as you can see below, the return value of greater-curry? is used as
;;function
;((greater-curry? 10) 5)
;#f
#|
The notion of currying stems from the branch of mathematics called lambda calculus.
It is necessary because in lambda calculus *eveything* is a one argument function;
so the need arises to deal with multiple arguments.
--
Practically, we will not use the strict definition of currying. For instance,
we might break up a 5 argument function into a 2arg one and 3 arg one; grouping the
arguments by their logical significance. This more "relaxed" version of currying is
refered to as "partially applied functions".

Q:
  When is this useful?
A: 
  Whenever you notice that you are passing the same values to the same subset of
  arguments you might consider currying that function or refactoring it to a 
  partially applied function.

--
Consider the following program which prints a shallow family tree of the major houses
from the fantasy series "A Song of Ice and Fire" by G.R.R. Martin (no spoilers included):
|#
(define (house-tree)
  (print-with-indent 2 "->" "Robert" "Baratheron" "the first of his name, King of the Andals and the Rhoynar and the First Men, Lord of the Seven Kingdoms and Protector of the Realm")
  (print-with-indent 4 "--" "Cersei" "Lannister" "Queen")
  (print-with-indent 4 "--" "Jeoffrey" "Baratheon" "Heir to the Iron Throne")
  (print-with-indent 4 "--" "Tommen" "Baratheon" "prince")
  (print-with-indent 4 "--" "Myrcella" "Baratheon" "princess")
    
  ;;house Stark
  (print-with-indent 2 "->" "Eddard" "Stark" "Lord of Winterfell, Warden of the North")
  (print-with-indent 4 "--" "Catelyn" "Stark, formerly Tully" "Lady of Winterfell")
  (print-with-indent 4 "--" "Robb" "Stark" "Heir of Winterfell")
  (print-with-indent 4 "--" "Jon" "Snow" "bastard son of Eddard")
  (print-with-indent 4 "--" "Sansa" "Stark" "eldest daughther")
  (print-with-indent 4 "--" "Arya" "Stark" "daughther")
  (print-with-indent 4 "--" "Bran" "Stark" "son")
  (print-with-indent 4 "--" "Rickon" "Stark" "son")
)
   
(define (n-spaces n)
  (if (zero? n)
     "" 
    (string-append " " (n-spaces (- n 1))))
)

(define (print-with-indent n-of-spaces line-start name house title)
  (print (string-append (n-spaces n-of-spaces)
                        line-start " "
                        name " "
                        "of house "
                        house ": "
                        title))
  (newline))

#|
As you can see in the (house-tree) function, many calls to "print-with-indent"
have the same two argument. To avoid having to write them explicitly every
time we can curry the function into:
|#
(define (print-with-indent-curry n-of-spaces line-start)
  (lambda (name house title)
    (print (string-append (n-spaces n-of-spaces)
                          line-start " "
                          name " "
                          "of house "
                          house ": "
                          title))
    (newline)
  )
)
#|
The two arguments that repeat themselves are passed in first, and in return
we get a function that will take the subsequent 3 arguments and use the initial
two to do the printing.
|#

(define (house-tree-curry)
  (let ((print-family (print-with-indent-curry 4 "--"))
        (print-house-head (print-with-indent-curry 2 "->")))
    ;;house Baratheon
    (print-house-head "Robert" "Baratheron" "King")
    (print-family "Cersei" "Lannister" "Queen")
    (print-family "Jeoffrey" "Baratheon" "Heir to the Iron Throne")
    (print-family "Tommen" "Baratheon" "prince")
    (print-family "Myrcella" "Baratheon" "princess")
    
    ;;house Stark
    (print-house-head "Eddard" "Stark" "Lord of Winterfell, Warden of the North")
    (print-family "Catelyn" "Stark, formerly Tully" "Lady of Winterfell")
    (print-family "Robb" "Stark" "Heir of Winterfell")
    (print-family "Jon" "Snow" "bastard son of Eddard")
    (print-family "Sansa" "Stark" "eldest daughther")
    (print-family "Arya" "Stark" "daughther")
    (print-family "Bran" "Stark" "son")
    (print-family "Rickon" "Stark" "son")
  ) 
)

#|
To better understand how this works consider how you would go about doing this in Java.

You start out with:
class HPrinter{
   void printWithIndent (nOfSpaces lineStart name house title){...}

   public static void printHouses(){
       HPrinter p = new HpPrinter();
       p.printWithIndent(2, "->", "Robert", "Baratheon", "King");
       p.printWithIndent(4, "--", "Cersei", "Lannister", "Queen");
       //...
   }
}

and you would transform it to:

class HPrinter{
   private final int nOfSpaces;
   private final String nOfSpaces;

   public HPrinter(int nOfSpaces, String lineStart){
     this.nOfSpaces = nOfSpaces;
     this.lineStart = lineStart;
   }

   void printWithIndent (nOfSpaces lineStart name house title){...}

   public static void printHouses(){
       HPrinter head = new HpPrinter(2, "->");
       HPrinter household = new HpPrinter(4, "--");
       head.printWithIndent(2, "->", "Robert", "Baratheon", "King");
       household.printWithIndent(4, "--", "Cersei", "Lannister", "Queen");
       //....
   }
}

For our example:
(define (print-with-indent-curry n-of-spaces line-start)
  (lambda (name house title) ...)

In the Java version the parameters of the constructor are stored in fields, in Scheme,
and other functional languages, the first two parameters are stored in
*closures*. So a simple way of thinking about closures is that they are to a
function what *immutable* fields are to an object.

If you think about it, the concept of a closure exists in Java as well. Consider
the following code that creates a Thread object using an anonymous definition
of a class that implements the interface Runnable:

class Foo{
  public void compute(){
     //this variable *has* to be final
     final int bar = 42;
     
     Thread t = new Thread(new Runnable{
         public void run(){
            System.out.println(bar);
         }
     });
     t.start();
  }

}

|#
