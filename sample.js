// Variable declarations
let a = 5;
const b = 10;
var c = 15;

// Conditional statements
if (a < b) {
    c = a + b;
} else {
    c = b - a;
}

// Loop statements
while (c > 0) {
    c = c - 1;
}



// Nested if-else
if (a > 10) {
    if (b < 20) {
        a = b * 2;
    } else {
        a = b / 2;
    }
}

// Function declaration (if supported in the grammar)
function add(x, y) {
    return x + y;
}

// Call the function
let x = add(a, b, c);

