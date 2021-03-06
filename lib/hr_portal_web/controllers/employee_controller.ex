defmodule HrPortalWeb.EmployeeController do
  use HrPortalWeb, :controller

  alias PayrollServices.Employees
  
  def index(conn, _params) do
    employees = Employees.list_employees
    render(conn, "index.html", employees: employees)
  end

  def search(conn, params) do
    search_term = get_in(params, ["query"])
    IO.puts inspect(search_term)
    with results = [_|_] <- Employees.search_employees(search_term) do {:ok, results} 
        conn
        |> render("index.html", employees: results)
    else _ -> 
        conn
        |> put_flash(:info, "No matching results found!")
        |> render("index.html", employees: [])
    end   
  end

  def new(conn, _params) do
    changeset = Employees.change_employee(%HumanResources.Employee{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"employee" => employee_params}) do
    case Employees.create_employee(employee_params) do
      {:ok, employee} ->
        conn
        |> put_flash(:info, "Employee created successfully.")
        |> redirect(to: Routes.employee_path(conn, :show, employee))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    employee = Employees.get_employee!(id)
    employee = Employees.preload(employee)
    render(conn, "show.html", employee: employee)
  end

  def edit(conn, %{"id" => id}) do
    employee = Employees.get_employee!(id)
    changeset = Employees.change_employee(employee)
    render(conn, "edit.html", employee: employee, changeset: changeset)
  end

  def update(conn, %{"id" => id, "employee" => employee_params}) do
    employee = Employees.get_employee!(id)

    case Employees.update_employee(employee, employee_params) do
      {:ok, employee} ->
        conn
        |> put_flash(:info, "Employee updated successfully.")
        |> redirect(to: Routes.employee_path(conn, :show, employee))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", employee: employee, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    employee = Employees.get_employee!(id)      
    {:ok, _employee} = Employees.delete_employee(employee)

    conn
     |> put_flash(:info, "Employee deleted successfully.")
     |> redirect(to: Routes.employee_path(conn, :index))
  end
end
