    const pool = require("../config/db");

    module.exports = {
      create: (data, callback) => {
        pool.getConnection((err, connection) => {
          if (err) {
            return callback(err);
          }
      
          connection.beginTransaction(err => {
            if (err) {
              connection.release();
              return callback(err);
            }
      
            const { name, email, password, roles = [], additionalData } = data; // Changed username to name
      
            // Check if email already exists
            connection.query(
              `SELECT id FROM users WHERE email = ?`,
              [email],
              (error, results) => {
                if (error) {
                  connection.release();
                  return callback(error);
                }
      
                if (results.length > 0) {
                  connection.release();
                  return callback(new Error('Email already exists'));
                }
      
                // Proceed with inserting the user
                connection.query(
                  `INSERT INTO users (name, email, password) VALUES (?, ?, ?)`,
                  [name, email, password], // Changed username to name
                  (error, results) => {
                    if (error) {
                      return connection.rollback(() => {
                        connection.release();
                        return callback(error);
                      });
                    }
      
                    const userId = results.insertId;
      
                    const roleQueries = roles.map(role => {
                      return new Promise((resolve, reject) => {
                        connection.query(
                          `SELECT id FROM roles WHERE role_name = ?`,
                          [role],
                          (error, results) => {
                            if (error) return reject(error);
                            if (results.length > 0) {
                              const roleId = results[0].id;
                              connection.query(
                                `INSERT INTO user_roles (user_id, role_id) VALUES (?, ?)`,
                                [userId, roleId],
                                (error, results) => {
                                  if (error) return reject(error);
                                  resolve();
                                }
                              );
                            } else {
                              console.error(`Role '${role}' not found in the database`);
                              reject(new Error(`Role '${role}' not found`));
                            }
                          }
                        );
                      });
                    });
      
                    Promise.allSettled(roleQueries)
                      .then((results) => {
                        const failedRoles = results.filter(result => result.status === 'rejected');
      
                        if (failedRoles.length > 0) {
                          return connection.rollback(() => {
                            connection.release();
                            callback(new Error(`Failed to assign roles: ${failedRoles.map(result => result.reason.message).join(', ')}`));
                          });
                        }
      
                        // Handle additional data based on roles
                        const queries = [];
      
                        if (roles.includes('common')) {
                          const customerData = [userId];
                          queries.push(new Promise((resolve, reject) => {
                            connection.query(
                              `INSERT INTO customers (user_id) VALUES (?)`,
                              customerData,
                              (error, results) => {
                                if (error) return reject(error);
                                resolve();
                              }
                            );
                          }));
                        }
      
                        if (roles.includes('farmer')) {
                          const farmerData = [
                            userId,
                            additionalData.homeAddress,
                            additionalData.contactNumber,
                            additionalData.nicNo,
                            additionalData.nicImage
                          ];
                          queries.push(new Promise((resolve, reject) => {
                            connection.query(
                              `INSERT INTO farmers (user_id, home_address, contact_number, nic_no, nic_image) VALUES (?, ?, ?, ?, ?)`,
                              farmerData,
                              (error, results) => {
                                if (error) return reject(error);
                                resolve();
                              }
                            );
                          }));
                        }
      
                        if (roles.includes('seller')) {
                          const sellerData = [
                            userId,
                            additionalData.shopName,
                            additionalData.shopAddress,
                            additionalData.shopRegNo,
                            additionalData.typeOfGoods,
                            additionalData.brImage
                          ];
                          queries.push(new Promise((resolve, reject) => {
                            connection.query(
                              `INSERT INTO sellers (user_id, shop_name, shop_address, shop_reg_no, type_of_goods, br_image) VALUES (?, ?, ?, ?, ?, ?)`,
                              sellerData,
                              (error, results) => {
                                if (error) return reject(error);
                                resolve();
                              }
                            );
                          }));
                        }
      
                        return Promise.all(queries);
                      })
                      .then(() => {
                        connection.commit(err => {
                          if (err) {
                            return connection.rollback(() => {
                              connection.release();
                              callback(err);
                            });
                          }
                          connection.release();
                          callback(null, { message: 'User registered successfully' });
                        });
                      })
                      .catch(error => {
                        return connection.rollback(() => {
                          connection.release();
                          callback(error);
                        });
                      });
                  }
                );
              }
            );
          });
        });
      },
          
        getUsers: (callback) => {
            const query = `
                SELECT u.id, u.name, u.email, u.password, 
                GROUP_CONCAT(DISTINCT r.role_name SEPARATOR ', ') as roles,
                f.home_address, f.contact_number, f.nic_no, f.nic_image,
                s.shop_name, s.shop_address, s.shop_reg_no, s.type_of_goods, s.br_image
                FROM users u
                LEFT JOIN user_roles ur ON u.id = ur.user_id
                LEFT JOIN roles r ON ur.role_id = r.id
                LEFT JOIN farmers f ON u.id = f.user_id
                LEFT JOIN sellers s ON u.id = s.user_id
                GROUP BY u.id;
            `;
            
            pool.query(query, (err, results) => {
                if (err) {
                    return callback(err, null);
                }
                return callback(null, results);
            });
        },
        
        
    
        getUserByUserId: (id, callback) => {
            const query = `
                SELECT u.id, u.name, u.email, u.password, 
                GROUP_CONCAT(DISTINCT r.role_name SEPARATOR ', ') as roles,
                f.home_address, f.contact_number, f.nic_no, f.nic_image,
                s.shop_name, s.shop_address, s.shop_reg_no, s.type_of_goods, s.br_image
                FROM users u
                LEFT JOIN user_roles ur ON u.id = ur.user_id
                LEFT JOIN roles r ON ur.role_id = r.id
                LEFT JOIN farmers f ON u.id = f.user_id
                LEFT JOIN sellers s ON u.id = s.user_id
                WHERE u.id = ?
                GROUP BY u.id;
            `;
            
            pool.query(query, [id], (error, results) => {
                if (error) {
                    return callback(error, null);
                }
                if (results.length === 0) {
                    return callback(new Error("User not found"), null);
                }
                return callback(null, results[0]);
            });
        },
    
        
        updateUsers: (data, callback) => {
            const { id, name, email, password, roles, additionalData } = data;
            
            // Start transaction
            pool.getConnection((err, connection) => {
                if (err) {
                    return callback(err, null);
                }
        
                connection.beginTransaction(err => {
                    if (err) {
                        connection.release();
                        return callback(err, null);
                    }
        
                    // Update basic user details
                    const updateUserQuery = `
                        UPDATE users 
                        SET name = ?, email = ?, password = ?
                        WHERE id = ?
                    `;
                    connection.query(updateUserQuery, [name, email, password, id], (error, results) => {
                        if (error) {
                            return connection.rollback(() => {
                                connection.release();
                                callback(error, null);
                            });
                        }
        
                        // Update user roles
                        const deleteRolesQuery = `
                            DELETE FROM user_roles
                            WHERE user_id = ?
                        `;
                        connection.query(deleteRolesQuery, [id], (error, results) => {
                            if (error) {
                                return connection.rollback(() => {
                                    connection.release();
                                    callback(error, null);
                                });
                            }
        
                            const roleQueries = roles.map(role => {
                                return new Promise((resolve, reject) => {
                                    connection.query(
                                        `SELECT id FROM roles WHERE role_name = ?`,
                                        [role],
                                        (error, results) => {
                                            if (error) return reject(error);
                                            if (results.length > 0) {
                                                connection.query(
                                                    `INSERT INTO user_roles (user_id, role_id) VALUES (?, ?)`,
                                                    [id, results[0].id],
                                                    (error, results) => {
                                                        if (error) return reject(error);
                                                        resolve();
                                                    }
                                                );
                                            } else {
                                                console.error(`Role '${role}' not found in the database`);
                                                reject(new Error('Role not found'));
                                            }
                                        }
                                    );
                                });
                            });
        
                            // Execute roleQueries in parallel
                            Promise.all(roleQueries)
                                .then(() => {
                                    // Update farmer details if applicable
                                    if (roles.includes('farmer')) {
                                        const updateFarmerQuery = `
                                            UPDATE farmers
                                            SET home_address = ?, contact_number = ?, nic_no = ?, nic_image = ?
                                            WHERE user_id = ?
                                        `;
                                        const { homeAddress, contactNumber, nicNo, nicImage } = additionalData;
                                        connection.query(updateFarmerQuery, [homeAddress, contactNumber, nicNo, nicImage, id], (error, results) => {
                                            if (error) return callback(error, null);
                                            // Commit transaction
                                            connection.commit(err => {
                                                if (err) {
                                                    return connection.rollback(() => {
                                                        connection.release();
                                                        callback(err, null);
                                                    });
                                                }
                                                connection.release();
                                                callback(null, { message: 'User updated successfully' });
                                            });
                                        });
                                    } else {
                                        // Update seller details if applicable
                                        if (roles.includes('seller')) {
                                            const updateSellerQuery = `
                                                UPDATE sellers
                                                SET shop_name = ?, shop_address = ?, shop_reg_no = ?, type_of_goods = ?, br_image = ?
                                                WHERE user_id = ?
                                            `;
                                            const { shopName, shopAddress, shopRegNo, typeOfGoods, brImage } = additionalData;
                                            connection.query(updateSellerQuery, [shopName, shopAddress, shopRegNo, typeOfGoods, brImage, id], (error, results) => {
                                                if (error) return callback(error, null);
                                                // Commit transaction
                                                connection.commit(err => {
                                                    if (err) {
                                                        return connection.rollback(() => {
                                                            connection.release();
                                                            callback(err, null);
                                                        });
                                                    }
                                                    connection.release();
                                                    callback(null, { message: 'User updated successfully' });
                                                });
                                            });
                                        } else {
                                            // Commit transaction if no farmer or seller details to update
                                            connection.commit(err => {
                                                if (err) {
                                                    return connection.rollback(() => {
                                                        connection.release();
                                                        callback(err, null);
                                                    });
                                                }
                                                connection.release();
                                                callback(null, { message: 'User updated successfully' });
                                            });
                                        }
                                    }
                                })
                                .catch(error => {
                                    return connection.rollback(() => {
                                        connection.release();
                                        callback(error, null);
                                    });
                                });
                        });
                    });
                });
            });
        },
        
        deleteUser: (userId, callback) => {
            pool.getConnection((err, connection) => {
                if (err) {
                    return callback(err);
                }
        
                connection.beginTransaction(err => {
                    if (err) {
                        connection.release();
                        return callback(err);
                    }
        
                    // Step 1: Delete from farmers table
                    connection.query(
                        `DELETE FROM farmers WHERE user_id = ?`,
                        [userId],
                        (error, results) => {
                            if (error) {
                                return connection.rollback(() => {
                                    connection.release();
                                    callback(error);
                                });
                            }
        
                            // Step 2: Delete from sellers table
                            connection.query(
                                `DELETE FROM sellers WHERE user_id = ?`,
                                [userId],
                                (error, results) => {
                                    if (error) {
                                        return connection.rollback(() => {
                                            connection.release();
                                            callback(error);
                                        });
                                    }
        
                                    // Step 3: Delete from users table
                                    connection.query(
                                        `DELETE FROM users WHERE id = ?`,
                                        [userId],
                                        (error, results) => {
                                            if (error) {
                                                return connection.rollback(() => {
                                                    connection.release();
                                                    callback(error);
                                                });
                                            }
        
                                            connection.commit(err => {
                                                if (err) {
                                                    return connection.rollback(() => {
                                                        connection.release();
                                                        callback(err);
                                                    });
                                                }
        
                                                connection.release();
                                                callback(null, { message: 'User and associated data deleted successfully' });
                                            });
                                        }
                                    );
                                }
                            );
                        }
                    );
                });
            });
        },
        
        getUserByEmail: (email, callback) => {
            pool.query(
                `select * from users where email = ?`,
                [email],
                (error,results,fields) =>{
                    if(error){
                        callback(error);
                    }
                    return callback(null,results[0])
                }
            );
        },
        

        
    };