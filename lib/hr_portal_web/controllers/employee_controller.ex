defmodule HrPortalWeb.EmployeeController do
  use HrPortalWeb, :controller

  alias PayrollServices.Employees
  
  def index(conn, _params) do
    employees = Employees.list_employees
    render(conn, "index.html", employees: employees)
  end

  #def new(conn, _params) do
  #  changeset = HrHub.change_employee(%Employee{})
  #  render(conn, "new.html", changeset: changeset)
  #end

  def create(conn, %{"employee" => employee_params}) do
    case Employees.create(employee_params) do
      {:ok, employee} ->
        conn
        |> put_flash(:info, "Employee created successfully.")
        |> redirect(to: Routes.employee_path(conn, :show, employee))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  #def show(conn, %{"id" => id}) do
  #  employee = HrHub.get_employee!(id)
  #  render(conn, "show.html", employee: employee)
  #end

  #def edit(conn, %{"id" => id}) do
  #  employee = HrHub.get_employee!(id)
  #  changeset = HrHub.change_employee(employee)
  #  render(conn, "edit.html", employee: employee, changeset: changeset)
  #end

  #def update(conn, %{"id" => id, "employee" => employee_params}) do
  #  employee = HrHub.get_employee!(id)

  # case HrHub.update_employee(employee, employee_params) do
  #    {:ok, employee} ->
  #      conn
  #      |> put_flash(:info, "Employee updated successfully.")
  #      |> redirect(to: Routes.employee_path(conn, :show, employee))

  #    {:error, %Ecto.Changeset{} = changeset} ->
  #      render(conn, "edit.html", employee: employee, changeset: changeset)
  #  end
  #3end

  #def delete(conn, %{"id" => id}) do
  #  employee = HrHub.get_employee!(id)
  #  {:ok, _employee} = HrHub.delete_employee(employee)

  #  conn
  #  |> put_flash(:info, "Employee deleted successfully.")
  #  |> redirect(to: Routes.employee_path(conn, :index))
  #end
end
