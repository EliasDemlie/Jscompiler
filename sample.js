let sum = 0;
for (let i = 1; i <= 10; i++) {
    if (i % 2 === 0) {
        continue;
    }
    sum += i;
}
console.log("Sum of odd numbers from 1 to 10 is:", sum);
