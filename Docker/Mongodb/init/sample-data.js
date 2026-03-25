db = db.getSiblingDB("interviewDB");

// USERS COLLECTION
db.users.insertMany([
  {
    name: "Amit Kumar",
    age: NumberInt(29),
    isActive: true,
    salary: NumberDecimal("75000.50"),
    createdAt: new Date(),

    hobbies: ["cricket", "coding", "movies"],

    address: {
      city: "Nashik",
      state: "Maharashtra",
      pincode: 422001
    },

    skills: [
      { name: "JavaScript", level: "advanced" },
      { name: "MongoDB", level: "advanced" }
    ],

    objectIdExample: ObjectId(),
    binaryData: BinData(0, "SGVsbG8="),
    nullField: null
  },

  {
    name: "Neha Singh",
    age: NumberInt(26),
    isActive: false,
    salary: NumberLong(1500000),
    createdAt: ISODate(),

    hobbies: ["design", "travel"],

    address: {
      city: "Pune",
      state: "Maharashtra",
      pincode: 411001
    },

    skills: [
      { name: "UI/UX", level: "expert" }
    ],

    regexField: /mongo/i
  }
]);

// ORDERS COLLECTION (for relationships concept)
db.orders.insertOne({
  userId: db.users.findOne()._id,
  product: "Laptop",
  price: 90000,
  quantity: 1,
  orderDate: new Date(),
  status: "DELIVERED"
});

// PRODUCTS COLLECTION
db.products.insertMany([
  {
    name: "Smartphone",
    price: 60000,
    tags: ["electronics", "mobile"],
    stock: 40,
    ratings: [5, 4, 4, 5],

    specs: {
      ram: "8GB",
      storage: "128GB"
    }
  }
]);