# Package-Management-System

The main goal of this assignment was to design a system to maximize employee utilization while minimizing the probability of loss.

First, I created a pipeline that the package will work through until it is shipped.
[Package_Management_System.pdf](https://github.com/ira2101/Package-Management-System/files/13606346/ONBOARDING.pdf)

Here are the strategies I used to minimize loss:
1. First, every employee in the facility is assigned to a role. These roles are categorized as presorter, onboarder, and shipper. After an employee is assigned to a role, they are also assigned to a zone within that role. The idea with this was to limit the number of different things an employee sees in their role. This way employees are only doing tasks that they are familiar with and that they know how to complete successfully.
2. Each zone has a certain capacity. When an employee is trying to put a package into a zone that has already reached capacity, then the employee takes a break for a very short period of time, and then they check again about whether they can fully process the package. There are a few benefits to this. One, this reduces the probabilty of loss because an employee is only focusing on one package at a time. Also, by taking a break, they are able to gain efficiency, which allows them to handle packages more efficiently and with a greater chance of success.
3. After packages enter into the facility, they are presorted based on specific categories and levels of priority. The first presort zone that packages can go to, and with the highest priorty, is the perishable zone, which is a place to put all perishables. This takes greatest priority because perishables may need to be kept in a climate-controlled environment and need other special instructions on how to handle them. The fragility zone has the next highest priority, and it is for packages that contain fragile items, which also need special instructions on how to handle. The large item zone has the next highest priority, and it is for packages that contain large items, which need special instructions on how to handle, such as forklifts, etc. And then with the lowest priority is the general category, which is for every other type of package. Organizing the packages the way we do reduces the chance that a package is mishandled because packages in each category are handled with a specific level of care and attention.
4. After presorting, packages are moved to a waiting zone where they are organized based on the routes they need to take to get to their destination. This reduces the chance of a package being mishandled because each package is placed with all other packages that are waiting to be shipped on a specific route.

I built a small SwiftUI iOS app, which I believe requires Xcode to run. Here are some simulations that I ran in case you don't have Xcode installed.

Here are some simulations that I ran:


https://github.com/ira2101/Package-Management-System/assets/54328228/daad0499-b590-4c61-9219-e6a5ef55e99a



https://github.com/ira2101/Package-Management-System/assets/54328228/49000308-9278-4005-9fe6-36a84c570763



https://github.com/ira2101/Package-Management-System/assets/54328228/35ac63fd-4619-4de7-95ac-74c640647e89



https://github.com/ira2101/Package-Management-System/assets/54328228/af0c689e-2eee-4644-bce4-43844dd79c05



https://github.com/ira2101/Package-Management-System/assets/54328228/1a4ec924-fa60-4568-be67-12e84f8e8d11



https://github.com/ira2101/Package-Management-System/assets/54328228/1cb04f55-09ee-484a-8813-bdc715ad6184

