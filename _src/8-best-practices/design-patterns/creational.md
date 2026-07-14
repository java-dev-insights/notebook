---
layout: page
title: Creational Design Patterns
permalink: /design-patterns/creational
# parent: Design Patterns
# nav_order: 2
---

[Back to Design Patterns](../design-patterns/){: .btn .btn-outline }

# {{page.title}}

---

<details markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

---

# Singleton Pattern

**Singleton Pattern**
-	Ensures that ***only one instance of the class exists in the java virtual machine*** with a **global** access to ***get the instance*** of the class.
-	Used for logging, drivers objects, caching and thread pool.
-	Used in other design patterns like Abstract Factory , Builder, Prototype, Facade etc. 
-	Used in core java classes also, for example java.lang.Runtime, java.awt.Desktop.

## Java Singleton Pattern
- private constructor.
- private static variable of the same class, the only instance of the class.
- public static method to get the instance.

![creational-singleton.png]({{site.cdn}}/design-patterns/creational-singleton.png)

```java
public class LazyInitializedSingleton {
    private static LazyInitializedSingleton instance;    
    private LazyInitializedSingleton(){}    
    public static LazyInitializedSingleton getInstance(){
        if(instance == null)
            instance = new LazyInitializedSingleton(); 
        return instance;
    }
}
```
- **Performance Drawback**, acquire a potentially unnecessary lock each time we want to get the instance.
- **To fix**, *we could instead start by verifying if we need to create the object in the first place and only in that case, we would acquire the lock.
 This is called **Double Checked Locking**.

> NOTE: This is not 100% singleton.

```java
public class DclSingleton {
    private static volatile DclSingleton instance;
    private DclSingleton(){}    
    public static DclSingleton getInstance() {
        if (instance == null) {
            synchronized (DclSingleton.class) {
                if (instance == null)
                    instance = new DclSingleton();
            }
        }
        return instance;
    }
}
```

## Broken by Reflection
```java
Constructor[] constructors = DclSingleton.class.getDeclaredConstructors();
for (Constructor constructor : constructors) {
   constructor.setAccessible(true);
   instanceTwo = (DclSingleton) constructor.newInstance();
   System.out.println(instanceOne.hashCode());
   System.out.println(instanceTwo.hashCode()); 
}  // Different hashcodes, means Singleton Broken
```
`Solution` : call public getInstance in constructor

## Broken by Serialization
```java
DclSingleton instanceOne = DclSingleton.getInstance();
ObjectOutput out = new ObjectOutputStream(new FileOutputStream("filename.ser"));
out.writeObject(instanceOne);
out.close();
//deserailize from file to object
ObjectInput in = new ObjectInputStream(new FileInputStream("filename.ser"));
DclSingleton instanceTwo = (DclSingleton) in.readObject();
in.close();        
System.out.println("instanceOne hashCode="+instanceOne.hashCode());
System.out.println("instanceTwo hashCode="+instanceTwo.hashCode());
```
`Solution `:
```java
// implement readResolve method 
protected Object readResolve() { 
    return instance; 
}
```
- `readResolve` is used for replacing the object read from the stream.
- `readObject()` is an existing method in `ObjectInputStream` class, while reading object at the time of deserialization readObject method internally check whether the class object which is being deserialized having readResolve method or not if readResolve method exist then it will invoke readResolve method and return the same instance.
- Writing readResolve method is a good practice to achieve pure singleton design pattern where no one can get another instance by serializing/deserializing.

## Close to Singleton
```java
public class DclSingleton { // Close to Singleton
    private static volatile DclSingleton instance;
    // Overcoming new XYZ() 
    private DclSingleton() {}
    // only way to avoid reflection is to have EnumSingleton

    // locking complete method with not be good for performance
    public static DclSingleton getInstance() {
        if (instance == null) {
            synchronized(DclSingleton.class) {
                // Performance, Lock only if need to instantiate
                if (instance == null)
                    instance = new DclSingleton();
            }
        }
        return instance;
    }

    // Fixing clone
    @Override
    protected Object clone() throws CloneNotSupportedException {
        throw new CloneNotSupportedException();
    }

    // Fixing Serialization
    protected Object readResolve() {
        return instance;
    }
}
```

## Enum Singleton
- ***To overcome Reflection, use Enum to implement Singleton.***
- Java ensures that any enum value is instantiated only once.
- Globally accessible.
- Drawback : ***does not allow lazy initialization***.
- ***enums don’t have any constructor*** so it is not possible for Reflection to utilize it.
- Enums have their by-default constructor, we can’t invoke them by ourself.
- **JVM handles the creation and invocation of enum constructors internally**.

```java
public enum EnumSingleton {
    INSTANCE;    
    public static void doSomething(){ //do something }
}
```

# Factory Pattern
- Used when we have a ***super class with multiple sub-classes*** and ***based on input***, we need to ***return one of the sub-class***.
- Responsibility of instantiation shifted from client program to factory class.
- Superclass can be interface, abstract class or a normal class.
- Factory class can be singleton or have a method(return subclass) as static.
- Based on input, subclass object is created.

```java
public abstract class Computer {	
  public abstract String getRAM();
  public abstract String getHDD();
  public abstract String getCPU();

  @Override
  public String toString(){
    return String.format("RAM= %s , HDD= %s, CPU= %s" , this.getRAM(), this.getHDD(), this.getCPU());
  }
}
```
```java
public class PC extends Computer {
  private String ram;
  private String hdd;
  private String cpu;

  public PC(String ram, String hdd, String cpu){
    this.ram=ram;    this.hdd=hdd;    this.cpu=cpu;
  }
  @Override
  public String getRAM() {return this.ram;}
  @Override
  public String getHDD() {return this.hdd;}
  @Override
  public String getCPU() {return this.cpu;}
}
```
```java
public class Server extends Computer {
  private String ram;
  private String hdd;
  private String cpu;

  public Server(String ram, String hdd, String cpu){
    this.ram=ram;    this.hdd=hdd;    this.cpu=cpu;
  }
  @Override
  public String getRAM() {return this.ram;}
  @Override
  public String getHDD() {return this.hdd;}
  @Override
  public String getCPU() { return this.cpu; }
}
```
```java
public class ComputerFactory {
    public static Computer getComputer(String type, String ram, String hdd, String cpu) {
        if ("PC".equalsIgnoreCase(type))
            return new PC(ram, hdd, cpu);
        else if ("Server".equalsIgnoreCase(type))
            return new Server(ram, hdd, cpu);
        return null;
    }
}
```
```java
public class TestFactory {
    public static void main(String[] args) {
        Computer pc = ComputerFactory.getComputer("pc", "2 GB", "500 GB", "2.4 GHz");
        Computer server = ComputerFactory.getComputer("server", "16 GB", "1 TB", "2.9 GHz");
        System.out.println("Factory PC Config::" + pc);
        System.out.println("Factory Server Config::" + server);
    }
}
// Output
Factory PC Config::RAM= 2 GB, HDD=500 GB, CPU=2.4 GHz
Factory Server Config::RAM= 16 GB, HDD=1 TB, CPU=2.9 GHz
```

## Advantages-Factory Design Pattern
- code for interface rather than implementation.
- instantiation responsibility moved out of client code.
- we can easily change PC implementation without affecting client code.
- abstraction between implementation and client classes through inheritance.

## JDK Examples-Factory Design Pattern
- **getInstance()** methods in java.util.Calendar, ResourceBundle and NumberFormat uses Factory pattern.
- **valueOf()** method in wrapper classes like Boolean, Integer etc.

# Abstract Factory Pattern
-	Abstract Factory pattern is ***factory of factories***.
-	In factory design patter, we have a single Factory class that returns the different sub-classes based on the input provided and factory class uses if-else or switch statement to achieve this.
-	In Abstract Factory pattern, we get rid of if-else block and have a factory class for each sub-class and then an Abstract Factory class that will return the sub-class based on the input factory class.

```java
public interface ComputerAbstractFactory {
  public Computer createComputer();
}
```
```java
public class ComputerFactory {
    public static Computer getComputer(ComputerAbstractFactory factory) {
        return factory.createComputer();
    }
}
```
```java
public class PCFactory implements ComputerAbstractFactory {
    private String ram;
    private String hdd;
    private String cpu;
    public PCFactory(String ram, String hdd, String cpu) {
        this.ram = ram;
        this.hdd = hdd;
        this.cpu = cpu;
    }
    @Override
    public Computer createComputer() {
        return new PC(ram, hdd, cpu);
    }
}
```
```java
public class ServerFactory implements ComputerAbstractFactory {
    private String ram;
    private String hdd;
    private String cpu;
    public ServerFactory(String ram, String hdd, String cpu) {
        this.ram = ram;
        this.hdd = hdd;
        this.cpu = cpu;
    }
    @Override
    public Computer createComputer() {
        return new Server(ram, hdd, cpu);
    }
}
```
```java
public class TestAbstractFactoryPattern {
    public static void main(String[] args) {
        testAbstractFactory();
    }
    private static void testAbstractFactory() {
        Computer pc = ComputerFactory.getComputer(new PCFactory("2 GB", "500 GB", "2.4 GHz"));
        Computer server = ComputerFactory.getComputer(new ServerFactory("16 GB", "1 TB", "2.9 GHz"));
        System.out.println("AbstractFactory PC Config::" + pc);
        System.out.println("AbstractFactory Server Config::" + server);
    }
}
```

## Advantages of Abstract Factory Design Pattern
-	code for interface rather than implementation.
-	factory of factories, ***easily extended for more products***.
-	can add subclass Laptop and LaptopFactory.
-	Robust and ***avoid conditional logic*** of Factory pattern.

## JDK Examples-Abstract Factory Design Pattern
-	javax.xml.parsers.DocumentBuilderFactory#newInstance()
-	javax.xml.transform.TransformerFactory#newInstance()
-	javax.xml.xpath.XPathFactory#newInstance()

![]({{site.cdn}}/design-patterns/creational-AbstractFactoryPattern.png)

# Builder Pattern

- Issues with Factory and Abstract Factory when the Object contain a lot of attributes.
  -	Too Many arguments to be passed
  -	optional parameters need to send as NULL.
- Probable Solution (But Not)
  -	provide a constructor with required parameters and then setter methods for optional parameters. 
  -	Problem - Inconsistent Object state until all attributes are set explicitly.
- Builder pattern solves the issue with
  - large number of optional parameters 
  -	inconsistent state
- ***It provides a way to build the object step-by-step and return the final constructed Object***.
- Builder Design Pattern
  -	 static nested class 
  -	 copy all the arguments from the outer class to the Builder class.
  -	 Builder class - public constructor for required attributes.
  -	 Builder class – setters for optional attributes, returns same Builder object after setting the optional attribute.
  -	Provide build() that will return the final Object needed by client program.

![]({{site.cdn}}/design-patterns/creational-builder.png)

```java
// Computer - only getter & no public constructor, get Computer object only via ComputerBuilder.
public class Computer {
    //required parameters
    private String HDD;
    private String RAM;
    //optional parameters
    private boolean isGraphicsCardEnabled;
    private boolean isBluetoothEnabled;

    // getter for all 4 fields

    private Computer(ComputerBuilder builder) {
        this.HDD = builder.HDD;
        this.RAM = builder.RAM;
        this.isGraphicsCardEnabled = builder.isGraphicsCardEnabled;
        this.isBluetoothEnabled = builder.isBluetoothEnabled;
    }

    //Builder Class
    public static class ComputerBuilder {
        //required parameters
        private String HDD;
        private String RAM;
        // optional parameters
        private boolean isGraphicsCardEnabled;
        private boolean isBluetoothEnabled;

        public ComputerBuilder(String hdd, String ram) {
            this.HDD = hdd;
            this.RAM = ram;
        }
        public ComputerBuilder setGraphicsCardEnabled(boolean isGraphicsCardEnabled) {
            this.isGraphicsCardEnabled = isGraphicsCardEnabled;
            return this;
        }
        public ComputerBuilder setBluetoothEnabled(boolean isBluetoothEnabled) {
            this.isBluetoothEnabled = isBluetoothEnabled;
            return this;
        }
        public Computer build() {
            return new Computer(this);
        }
    }
}
```
```java
public class TestBuilderPattern {
    public static void main(String[] args) {
        //Using builder to get object without any inconsistent state or arguments management issues
        Computer comp = new Computer.ComputerBuilder("500 GB", "2 GB").setBluetoothEnabled(true).setGraphicsCardEnabled(true).build();
    }
}
```

## JDK Example-Builder Design Pattern
-	java.lang.StringBuilder#append() (unsynchronized)
-	java.lang.StringBuffer#append() (synchronized)

# Prototype Pattern
-	Used when ***Object creation is a costly affair*** and requires a lot of time and resources, and a ***similar object already exists***. 
-	Provides a ***copy mechanism from original to new, and then modify it***. 
-	Uses java cloning to copy the object hence ***object should be clonable***.
-	However, whether to use shallow or deep copy depends on the requirements and its a design decision.

```java
public class Employees implements Cloneable {
    private List<String> empList;

    public Employees() {
        empList = new ArrayList<String> ();
    }

    public Employees(List<String> list) {
        this.empList = list;
    }

    public void loadData() {
        //read all employees from database and put into the list
        empList.add("Pankaj");
        empList.add("Raj");
        empList.add("David");
        empList.add("Lisa");
    }

    public List<String> getEmpList() {
        return empList;
    }

    @Override
    public Object clone() throws CloneNotSupportedException {
        List<String> temp = new ArrayList<String> ();
        for (String s: this.getEmpList()) {
            temp.add(s);
        }
        return new Employees(temp);
    }
}
```
```java
public class TestPrototypePattern {
    public static void main(String[] args) throws CloneNotSupportedException {
        Employees emps = new Employees();
        emps.loadData();
        //Use the clone method to get the Employee object
        Employees empsNew = (Employees) emps.clone();
        Employees empsNew1 = (Employees) emps.clone();
        List<String> list = empsNew.getEmpList();
        list.add("John");
        List<String> list1 = empsNew1.getEmpList();
        list1.remove("Pankaj");
        System.out.println("emps List: " + emps.getEmpList());
        System.out.println("empsNew List: " + list);
        System.out.println("empsNew1 List: " + list1);
    }
}
```
